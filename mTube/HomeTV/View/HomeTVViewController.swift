//
//  HomeTVViewController.swift
//  mTube
//
//  Created by Marwan Osama on 2/13/21.
//

import UIKit
import XLPagerTabStrip
import Combine


class HomeTVViewController: UIViewController, IndicatorInfoProvider {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let cardsCellIdentifier = "CardsTableViewCell"
    let trendingCellIdentifier = "TrendingTableViewCell"
    let genresCellIdentifier = "GenresTableViewCell"
    
    var refreshControl = UIRefreshControl()
    
    private lazy var viewModel: HomeTVViewModel = {
        return HomeTVViewModel()
    }()
    
    var subscribtion = [AnyCancellable]()
    
    var mostPopularTV = [TvResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var topRatedTV = [TvResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var trendingTV = [TvResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initVM()
        configureUI()
        configureTableView()
        setupRefreshControl()
    }
    
    func initVM() {
        
        subscribtion = [
            viewModel.$contentAlpha.assign(to: \.alpha, on: contentsView),
            viewModel.$isLoading.sink(receiveValue: {
                if $0 {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
            }),
            viewModel.$mostPopularTV.assign(to: \.mostPopularTV, on: self),
            viewModel.$topRatedTV.assign(to: \.topRatedTV, on: self),
            viewModel.$trendingTV.assign(to: \.trendingTV, on: self)
        
        ]
        
        
        viewModel.getMostPopularTV()
        viewModel.getTopRatedTV()
        viewModel.getTrendingTV()
    }
    
    func setupRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: [:])
        refreshControl.backgroundColor = UIColor.gray.darken(byPercentage: 0.4)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
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
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
            $0.tableFooterView = UIView()
            $0.register(UINib(nibName: cardsCellIdentifier, bundle: nil), forCellReuseIdentifier: cardsCellIdentifier)
            $0.register(UINib(nibName: trendingCellIdentifier, bundle: nil), forCellReuseIdentifier: trendingCellIdentifier)
        }
    }
    
    func tvSelection(tv: TvResult) {
        let vc = UIStoryboard(name: "ShowDetails", bundle: nil).instantiateInitialViewController() as? ShowDetailsViewController
        vc?.id = tv.id
        vc?.classification = .tv
        vc?.title = tv.name
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func goToSeeAllList(classification: Classifications, sort: ShowSorting, title: String) {
        let vc = UIStoryboard(name: "SeeAllList", bundle: nil).instantiateInitialViewController() as? SeeAllListViewController
        vc?.classification = classification
        vc?.sorting = sort
        vc?.title = title
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func handleRefresh(_ sender: AnyObject) {
        viewModel.getMostPopularTV()
        viewModel.getTopRatedTV()
        viewModel.getTrendingTV()
    }
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TV")
    }
    

}

extension HomeTVViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: trendingCellIdentifier, for: indexPath) as! TrendingTableViewCell
            cell.classification = .tv
            cell.tvModels = trendingTV
            cell.cellSelection = { [weak self] (movie, tv) in
                guard let tv = tv else { return }
                self?.tvSelection(tv: tv)
            }
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardsCellIdentifier, for: indexPath) as! CardsTableViewCell
            cell.categoryLabel.text = "Most Popular TV Shows"
            cell.cardCellOptions = .MostPopularTV
            cell.tvModels = self.mostPopularTV
            
            cell.cellSelection = { [weak self] (movie, tv, filmography) in
                guard let self = self else { return }
                self.tvSelection(tv: tv!)
            }
            
            cell.seeAllTapped = { [weak self] in
                self?.goToSeeAllList(classification: .tv, sort: .popular, title: "Most Popular TV Shows")
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardsCellIdentifier, for: indexPath) as! CardsTableViewCell
            cell.categoryLabel.text = "Top Rated TV Shows"
            cell.cardCellOptions = .topRatedTV
            cell.tvModels = self.topRatedTV
            
            cell.cellSelection = { [weak self] (movie, tv, filmography) in
                guard let self = self else { return }
                self.tvSelection(tv: tv!)
            }
            
            cell.seeAllTapped = { [weak self] in
                self?.goToSeeAllList(classification: .tv, sort: .topRated, title: "Top Rated TV Shows")
            }
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            return 360
        }
    }
    
    
    
    
    
}
