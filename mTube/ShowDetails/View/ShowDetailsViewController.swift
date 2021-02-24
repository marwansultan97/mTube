//
//  ShowDetailsViewController.swift
//  mTube
//
//  Created by Marwan Osama on 2/17/21.
//

import UIKit
import Combine
import youtube_ios_player_helper
import ChameleonFramework

class ShowDetailsViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var id: Int?
    var classification: Classifications?
    private let detailsCell = "DetailsTableViewCell"
    private let cardsCell = "CardsTableViewCell"
    private let trailerCell = "TrailerTableViewCell"
    private let imagesCell = "ImagesTableViewCell"
    var subscribtion = Set<AnyCancellable>()
    private lazy var viewModel: ShowDetailsViewModel = {
        return ShowDetailsViewModel()
    }()
    
    var movieDetails: MoviesDetails? {
        didSet {
            guard movieDetails != nil else { return }
            tableView.reloadData()
        }
    }
    
    var tvDetails: TvDetails? {
        didSet {
            guard tvDetails != nil else { return }
            tableView.reloadData()
        }
    }
    
    var showImages: [Backdrop] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var showCast: [Cast] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var showVideo: Video? {
        didSet {
            guard showVideo != nil else { return }
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
            viewModel.$movieDetails.assign(to: \.movieDetails, on: self),
            viewModel.$tvDetails.assign(to: \.tvDetails, on: self),
            viewModel.$showImages.assign(to: \.showImages, on: self),
            viewModel.$showVideos.assign(to: \.showVideo, on: self),
            viewModel.$showCast.assign(to: \.showCast, on: self)
        ]
        
        viewModel.getShowDetails(classification: classification!, id: id!)
        viewModel.getShowImages(classification: classification!, id: id!)
        viewModel.getShowCast(classification: classification!, id: id!)
        viewModel.getShowVideo(classification: classification!, id: id!)
        
    }
    
    func configureUI() {
        view.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
    }
    
    func configureTableView() {
        tableView.apply {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
            $0.register(UINib(nibName: detailsCell, bundle: nil), forCellReuseIdentifier: detailsCell)
            $0.register(UINib(nibName: cardsCell, bundle: nil), forCellReuseIdentifier: cardsCell)
            $0.register(UINib(nibName: imagesCell, bundle: nil), forCellReuseIdentifier: imagesCell)
            $0.register(UINib(nibName: trailerCell, bundle: nil), forCellReuseIdentifier: trailerCell)
        }
    }
    

}

extension ShowDetailsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: trailerCell, for: indexPath) as! TrailerTableViewCell
            guard let showVideo = showVideo else { return cell }
            cell.configureCell(video: showVideo)
            
            cell.playerIsReadyClosure = {
                cell.loadingLabel.alpha = 0
                cell.playerView.alpha = 1
            }
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCell, for: indexPath) as! DetailsTableViewCell
            
            switch classification {
            case.movies:
                guard let model = self.movieDetails else { return cell }
                cell.genres = model.genres
                cell.configureCell(movie: model, tv: nil, person: nil)
            case.tv:
                guard let model = self.tvDetails else { return cell }
                cell.genres = model.genres
                cell.configureCell(movie: nil, tv: model, person: nil)
                
            case .person, .none:
                break
            }
            
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardsCell, for: indexPath) as! CardsTableViewCell
            cell.cardCellOptions = .showCast
            cell.showCast = self.showCast
            cell.categoryLabel.text = "Cast"
            cell.seeAllButton.alpha = 0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: imagesCell, for: indexPath) as! ImagesTableViewCell
            cell.showImages = showImages
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 1{
            return 360
        } else if indexPath.row == 2{
            return 360
        } else {
            return 280
        }
        
    }

    
}
