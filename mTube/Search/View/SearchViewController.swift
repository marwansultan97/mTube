//
//  SearchViewController.swift
//  mTube
//
//  Created by Marwan Osama on 2/21/21.
//

import UIKit
import Combine
import ChameleonFramework

class SearchViewController: UIViewController {

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentsView: UIView!
    
    let cellIdentifier = "SeeAllListTableViewCell"
    let searchController = UISearchController(searchResultsController: nil)
    
    var subscription = Set<AnyCancellable>()
    
    lazy var viewModel: SearchViewModel = {
        return SearchViewModel()
    }()
    
    var results: [SearchResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureSearchBar()
        configureTableView()
        setSubscription()
        setupSearchBarListener()
        
    }

    
    func setSubscription() {
        subscription = [
            viewModel.$contentAlpha.assign(to: \.alpha, on: contentsView),
            viewModel.$isLoading.sink(receiveValue: {
                if $0 {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }),
            viewModel.$results.assign(to: \.results, on: self),
            viewModel.$errorMessage.assign(to: \.text, on: errorLabel)
        
        ]
    }
    
    func setupSearchBarListener() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher
            .map { ($0.object as! UITextField).text }
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .sink { (str) in
                guard str != nil , str != "" , str != " " else { return }
                self.viewModel.getSearchResults(query: str!, pagination: false)
            }.store(in: &subscription)
    }
    
    func configureUI() {

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.blue.darken(byPercentage: 0.9)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
                
        view.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        contentsView.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        activityIndicator.color = .white
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
    }

    func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.apply {
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.apply {
                $0.tintColor = .black
                $0.delegate = self
                $0.autocapitalizationType = .none
                $0.backgroundColor = UIColor.blue.darken(byPercentage: 0.9)
                $0.searchTextField.apply {
                    $0.borderStyle = .none
                    $0.keyboardAppearance = .dark
                    $0.backgroundColor = .white
                    $0.layer.cornerRadius = 15
                    $0.textColor = .black
                    $0.attributedPlaceholder = NSAttributedString(string: "Search mTube", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                    $0.leftView?.tintColor = .black
                }
            }
        }
    }
    
    
    func configureTableView() {
        tableView.apply {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.rowHeight = 120
            $0.keyboardDismissMode = .onDrag
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
            $0.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }

    }
    
    func cellSelection(searchResult: SearchResults, classification: Classifications) {
        let vc = UIStoryboard(name: "ShowDetails", bundle: nil).instantiateInitialViewController() as? ShowDetailsViewController
        vc?.id = searchResult.id
        vc?.classification = classification
        switch classification {
        case .movies:
            vc?.title = searchResult.title
        case .tv:
            vc?.title = searchResult.name
        case .person:
            break
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

extension SearchViewController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SeeAllListTableViewCell
        let model = results[indexPath.row]
        cell.configureSearchCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = results[indexPath.row]
        switch model.mediaType {
        case .movie:
            cellSelection(searchResult: model, classification: .movies)
        case .tv:
            cellSelection(searchResult: model, classification: .tv)
        case .person:
            let vc = UIStoryboard(name: "PersonDetails", bundle: nil).instantiateInitialViewController() as? PersonDetailsViewController
            vc?.id = model.id
            vc?.title = model.name
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollHeight = scrollView.frame.height
        if position > contentHeight - scrollHeight {
            guard results.count < viewModel.totalResults! else { return }
            guard !viewModel.isPaginating else { return }
            viewModel.getSearchResults(query: searchController.searchBar.searchTextField.text!, pagination: true)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchController.searchBar.searchTextField.text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = searchController.searchBar.searchTextField.text
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.contentsView.alpha = 0
    }
}

