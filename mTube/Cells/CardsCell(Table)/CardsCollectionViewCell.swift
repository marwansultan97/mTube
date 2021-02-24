//
//  CardsCollectionViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/13/21.
//

import UIKit
import ChameleonFramework
import SDWebImage

class CardsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var starWidth: NSLayoutConstraint!
    @IBOutlet weak var starHeight: NSLayoutConstraint!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var rateLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    func configureUI() {
        backgroundColor = UIColor.blue.darken(byPercentage: 0.85)
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
        
        let path = UIBezierPath(roundedRect: movieImageView.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 8, height: 8))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        movieImageView.layer.mask = shapeLayer
    }
    
    func configureTopRated(movieModel: MoviesResult?, tvModel: TvResult?) {
        if let movieModel = movieModel {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(movieModel.posterPath)")
            movieImageView.sd_setImage(with: url, completed: nil)
            movieNameLabel.text = movieModel.originalTitle
            movieNameLabel.numberOfLines = 2
            rateLabel.text = "\(movieModel.voteAverage)"
            starImageView.alpha = 1
            rateLabelLeading.constant = 25
        }
        if let tvModel = tvModel {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(tvModel.posterPath)")
            movieImageView.sd_setImage(with: url, completed: nil)
            movieNameLabel.text = tvModel.name
            movieNameLabel.numberOfLines = 2
            rateLabel.text = "\(tvModel.voteAverage)"
            starImageView.alpha = 1
            rateLabelLeading.constant = 25
        }
        
        
    }
    
    func configureMostPopular(movieModel: MoviesResult?, tvModel: TvResult?) {
        if let movieModel = movieModel {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(movieModel.posterPath)")
            movieImageView.sd_setImage(with: url, completed: nil)
            movieNameLabel.text = movieModel.originalTitle
            movieNameLabel.numberOfLines = 2
            starImageView.alpha = 0
            rateLabelLeading.constant = 5
        }
        
        if let tvModel = tvModel {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(tvModel.posterPath)")
            movieImageView.sd_setImage(with: url, completed: nil)
            movieNameLabel.text = tvModel.name
            movieNameLabel.numberOfLines = 2
            starImageView.alpha = 0
            rateLabelLeading.constant = 5
        }
        
        
    }
    
    func configureUpcoming(model: MoviesResult, dateString: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(model.posterPath)")
        movieImageView.sd_setImage(with: url, completed: nil)
        movieNameLabel.text = model.originalTitle
        movieNameLabel.numberOfLines = 2
        starImageView.alpha = 0
        rateLabelLeading.constant = 5
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-mm-dd"
        let date = dateformatter.date(from: dateString)
        
        let dateformatter2 = DateFormatter()
        dateformatter2.dateFormat = "MMM yyyy"
        let dateToDisplay = dateformatter2.string(from: date!)
        rateLabel.text = dateToDisplay
    }
    
    func configureShowCast(model: Cast) {
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(model.profilePath ?? "")")
        movieImageView.sd_setImage(with: url, completed: nil)
        movieNameLabel.text = "\(model.name)\n(\(model.character ?? ""))"
        movieNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        movieNameLabel.numberOfLines = 3
        starImageView.alpha = 0
        rateLabel.alpha = 0
    }
    
    func configureFilmography(model: Filmography) {
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(model.posterPath ?? "")")
        movieImageView.sd_setImage(with: url, completed: nil)
        movieNameLabel.text = "\(model.title)\n(\(model.character ?? "")"
        movieNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        movieNameLabel.numberOfLines = 3
        starImageView.alpha = 0
        rateLabel.alpha = 0
    }
    
    

}
