//
//  CardsTableViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/13/21.
//



import UIKit
import ChameleonFramework


class CardsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    let collectionViewCellIdentifier = "CardsCollectionViewCell"
    
    var moviesModels: [MoviesResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var tvModels: [TvResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var showCast: [Cast] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var personFilmography: [Filmography] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var cardCellOptions: CardCellOptions?
    var upcomingDateString: String = ""
    
    var cellSelection: ((_ movies: MoviesResult?, _ tv: TvResult?, _ filmography: Filmography?)->())?
    var seeAllTapped: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        configureUI()
        configureCollectionView()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        categoryLabel.textColor = FlatOrange()
        contentView.backgroundColor = UIColor.flatBlue().darken(byPercentage: 0.45)
        separatorLine.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
    }
    
    func configureCollectionView() {
        collectionView.apply {
            $0.backgroundColor = UIColor.flatBlue().darken(byPercentage: 0.45)
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: collectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
        }
    }
    
    
    @IBAction func seeAllTapped(_ sender: UIButton) {
        seeAllTapped?()
    }
    
    //MARK: - CollectionView Configurations
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 280)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch self.cardCellOptions {
        
        case .mostPopularMovies, .topRatedMovies, .UpComingMovies:
            return moviesModels.count
            
        case .MostPopularTV, .topRatedTV:
            return tvModels.count
        
        case .showCast:
            return showCast.count
            
        case .personFilmography:
            return personFilmography.count
            
        case .none:
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! CardsCollectionViewCell
        
        switch self.cardCellOptions {
        
        case .mostPopularMovies:
            let model = moviesModels[indexPath.row]
            cell.configureMostPopular(movieModel: model, tvModel: nil)
            cell.rateLabel.text = "# \(indexPath.row+1)"
            
        case .topRatedMovies:
            let model = moviesModels[indexPath.row]
            cell.configureTopRated(movieModel: model, tvModel: nil)
            
        case .UpComingMovies:
            let model = moviesModels[indexPath.row]
            cell.configureUpcoming(model: model, dateString: upcomingDateString)
            
        case .MostPopularTV:
            let model = tvModels[indexPath.row]
            cell.configureMostPopular(movieModel: nil, tvModel: model)
            cell.rateLabel.text = "# \(indexPath.row+1)"
            
        case .topRatedTV:
            let model = tvModels[indexPath.row]
            cell.configureTopRated(movieModel: nil, tvModel: model)
            
        case .showCast:
            let model = showCast[indexPath.row]
            cell.configureShowCast(model: model)
            
        case .personFilmography:
            let model = personFilmography[indexPath.row]
            cell.configureFilmography(model: model)
            
        case .none:
            break
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch self.cardCellOptions {
        
        case .mostPopularMovies, .topRatedMovies, .UpComingMovies:
            let model = moviesModels[indexPath.row]
            cellSelection?(model, nil, nil)
            
        case .MostPopularTV, .topRatedTV:
            let model = tvModels[indexPath.row]
            cellSelection?(nil, model, nil)
        
        case .none, .showCast:
            break
        case .personFilmography:
            let model = personFilmography[indexPath.row]
            cellSelection?(nil, nil, model)
        }
        
    }
    
}

enum CardCellOptions {
    case mostPopularMovies
    case topRatedMovies
    case UpComingMovies
    case MostPopularTV
    case topRatedTV
    case showCast
    case personFilmography
}
