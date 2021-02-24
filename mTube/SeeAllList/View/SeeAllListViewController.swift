//
//  SeeAllListViewController.swift
//  mTube
//
//  Created by Marwan Osama on 2/20/21.
//

import UIKit
import Combine
import ChameleonFramework

class SeeAllListViewController: UIViewController {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "SeeAllListTableViewCell"
    
    var classification: Classifications?
    var sorting: ShowSorting?
    var genreID: Int?
    
    var subscribtion = Set<AnyCancellable>()
    lazy var viewModel: SeeAllListViewModel = {
        return SeeAllListViewModel()
    }()
    
    var movieModels: [MoviesResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var tvModels: [TvResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var genreModels: [MoviesResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubscribtion()
        configureUI()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigationApperance = UINavigationBarAppearance()
        navigationApperance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationApperance.backgroundColor = UIColor.blue.darken(byPercentage: 0.9)
        navigationItem.standardAppearance = navigationApperance
        navigationItem.compactAppearance = navigationApperance
        navigationItem.scrollEdgeAppearance = navigationApperance
    }
    
    func setSubscribtion() {
        subscribtion = [
            
            viewModel.$contentAlpha.assign(to: \.alpha, on: contentsView),
            viewModel.$isLoading.sink(receiveValue: { [weak self] in
                if $0 {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }),
            viewModel.$movieList.assign(to: \.movieModels, on: self),
            viewModel.$tvList.assign(to: \.tvModels, on: self),
            viewModel.$genreList.assign(to: \.genreModels, on: self)
        
        ]
        if let classification = classification {
            viewModel.getList(classification: classification, sorting: sorting!, pagination: false)
        }
        
        if let genreID = genreID {
            viewModel.getGenreList(genreID: genreID, pagination: false)
        }
        
    }
    
    func configureUI() {
        contentsView.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        view.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        activityIndicator.color = .white
    }
    
    func configureTableView() {
        tableView.apply {
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 120
            $0.tableFooterView = UIView()
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
            $0.separatorStyle = .none
            $0.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }
    
    func showSelection(id: Int) {
        let vc = UIStoryboard(name: "ShowDetails", bundle: nil).instantiateInitialViewController() as? ShowDetailsViewController
        vc?.classification = classification
        vc?.id = id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    

}

extension SeeAllListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let classification = classification {
            switch classification {
            case .movies:
                return movieModels.count
            case .tv:
                return tvModels.count
            case .person:
                return 0
            }
        } else {
            return genreModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SeeAllListTableViewCell
        if let classification = classification {
            switch classification {
            case .movies:
                let movie = self.movieModels[indexPath.row]
                cell.configureCell(movie: movie, tv: nil)
            case .tv:
                let tv = self.tvModels[indexPath.row]
                cell.configureCell(movie: nil, tv: tv)
            case .person:
                break
            }
        }
        if let genreID = genreID {
            let movie = genreModels[indexPath.row]
            cell.configureCell(movie: movie, tv: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let classification = classification {
            switch classification {
            case .movies:
                let movie = movieModels[indexPath.row]
                showSelection(id: movie.id)
            case .tv:
                let tv = tvModels[indexPath.row]
                showSelection(id: tv.id)
            case .person:
                break
            }
        }
        
        if let genreID = genreID {
            let movie = genreModels[indexPath.row]
            showSelection(id: movie.id)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.height
        let contentHeight = tableView.contentSize.height
        if position > contentHeight - scrollViewHeight {
            if let classification = classification {
                guard !viewModel.isPaginating else { return }
                viewModel.getList(classification: classification, sorting: sorting!, pagination: true)
            } else {
                viewModel.getGenreList(genreID: genreID!, pagination: true)
            }
            
        }
    }
    
    
}
