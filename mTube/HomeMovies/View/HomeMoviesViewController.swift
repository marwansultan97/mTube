//
//  HomeViewController.swift
//  mTube
//
//  Created by Marwan Osama on 2/13/21.
//

import UIKit
import Combine
import XLPagerTabStrip
import ChameleonFramework

class HomeMoviesViewController: UIViewController, IndicatorInfoProvider {
    

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let cardsCellIdentifier = "CardsTableViewCell"
    let trendingCellIdentifier = "TrendingTableViewCell"
    let genresCellIdentifier = "GenresTableViewCell"
    
    var refreshControl = UIRefreshControl()
    var subscribtion = [AnyCancellable]()
    private lazy var viewModel: HomeMoviesViewModel = {
        return HomeMoviesViewModel()
    }()
    
    var mostPopularMovies = [MoviesResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var topRatedMovies = [MoviesResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var upcomingMovies = [MoviesResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var trendingMovies = [MoviesResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var upcominDate = "" {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var genres = [Genre]() {
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
            viewModel.$mostPopularMovies.assign(to: \.mostPopularMovies, on: self),
            viewModel.$topRatedMovies.assign(to: \.topRatedMovies, on: self),
            viewModel.$upcomingMovies.assign(to: \.upcomingMovies, on: self),
            viewModel.$upcomingDate.assign(to: \.upcominDate, on: self),
            viewModel.$genres.assign(to: \.genres, on: self),
            viewModel.$trendingMovies.assign(to: \.trendingMovies, on: self)
        
        ]
        
        
        viewModel.getMostPopularMovies()
        viewModel.getTopRatedMovies()
        viewModel.getUpcomingMovies()
        viewModel.getTrendingMovies()
        viewModel.getGenres()
    }
    
    func setupRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.apply {
            $0.attributedTitle = NSAttributedString(string: "", attributes: [:])
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.4)
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
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
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
            $0.tableFooterView = UIView()
            $0.register(UINib(nibName: trendingCellIdentifier, bundle: nil), forCellReuseIdentifier: trendingCellIdentifier)
            $0.register(UINib(nibName: cardsCellIdentifier, bundle: nil), forCellReuseIdentifier: cardsCellIdentifier)
            $0.register(UINib(nibName: genresCellIdentifier, bundle: nil), forCellReuseIdentifier: genresCellIdentifier)
        }
    }
    
    func moviesSelection(movie: MoviesResult) {
        let vc = UIStoryboard(name: "ShowDetails", bundle: nil).instantiateInitialViewController() as? ShowDetailsViewController
        vc?.id = movie.id
        vc?.classification = .movies
        vc?.title = movie.title
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
        viewModel.getMostPopularMovies()
        viewModel.getTopRatedMovies()
        viewModel.getUpcomingMovies()
        viewModel.getTrendingMovies()
        viewModel.getGenres()
    }
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Movies")
    }

}

extension HomeMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: trendingCellIdentifier, for: indexPath) as! TrendingTableViewCell
            cell.classification = .movies
            cell.movieModels = self.trendingMovies
            
            cell.cellSelection = { [weak self] (movie, tv) in
                guard let movie = movie else { return }
                self?.moviesSelection(movie: movie)
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardsCellIdentifier, for: indexPath) as! CardsTableViewCell
            cell.categoryLabel.text = "Most Popular Movies"
            cell.cardCellOptions = .mostPopularMovies
            cell.moviesModels = self.mostPopularMovies
            
            cell.cellSelection = { [weak self] (movie, tv, filmography) in
                guard let movie = movie else { return }
                self?.moviesSelection(movie: movie)
            }
            
            cell.seeAllTapped = { [weak self] in
                self?.goToSeeAllList(classification: .movies, sort: .popular, title: "Most Popular Movies")
            }
            
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardsCellIdentifier, for: indexPath) as! CardsTableViewCell
            cell.categoryLabel.text = "Top Rated Movies"
            cell.cardCellOptions = .topRatedMovies
            cell.moviesModels = self.topRatedMovies
            
            cell.cellSelection = { [weak self] (movie, tv, filmography) in
                guard let movie = movie else { return }
                self?.moviesSelection(movie: movie)
            }
            
            cell.seeAllTapped = { [weak self] in
                self?.goToSeeAllList(classification: .movies, sort: .topRated, title: "Top Rated Movies")
            }
            
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardsCellIdentifier, for: indexPath) as! CardsTableViewCell
            cell.categoryLabel.text = "Upcoming Movies"
            cell.cardCellOptions = .UpComingMovies
            cell.moviesModels = self.upcomingMovies
            cell.upcomingDateString = self.upcominDate
            
            cell.cellSelection = { [weak self] (movie, tv, filmography) in
                guard let movie = movie else { return }
                self?.moviesSelection(movie: movie)
            }
            
            cell.seeAllTapped = { [weak self] in
                self?.goToSeeAllList(classification: .movies, sort: .upcoming, title: "Upcoming Movies")
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: genresCellIdentifier, for: indexPath) as! GenresTableViewCell
            cell.genres = self.genres
            
            cell.cellSelection = { [weak self] (id, name) in
                guard let self = self else { return }
                let vc = UIStoryboard(name: "SeeAllList", bundle: nil).instantiateInitialViewController() as? SeeAllListViewController
                vc?.genreID = id
                vc?.title = name
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else if indexPath.row == 4 {
            return 260
        } else {
            return 360
        }
    }
    
    
    
    
}

