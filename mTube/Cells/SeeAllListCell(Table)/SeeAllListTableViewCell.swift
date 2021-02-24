//
//  SellAllListTableViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/20/21.
//

import UIKit

class SeeAllListTableViewCell: UITableViewCell {

    @IBOutlet weak var rateLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = UIColor.flatBlue().darken(byPercentage: 0.45)
    }
    
    func configureCell(movie: MoviesResult?, tv: TvResult?) {
        if let movie = movie {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(movie.posterPath)")
            posterImageView.sd_setImage(with: url, completed: nil)
            showNameLabel.text = movie.originalTitle
            rateLabel.text = "\(movie.voteAverage)"
            dateLabel.text = "\(convertDate(dateString: movie.releaseDate))"
            
        }
        
        if let tv = tv {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(tv.posterPath)")
            posterImageView.sd_setImage(with: url, completed: nil)
            showNameLabel.text = tv.originalName
            rateLabel.text = "\(tv.voteAverage)"
            dateLabel.text = "\(convertDate(dateString: tv.firstAirDate))"
        }
    }
    
    func convertDate(dateString: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter1.date(from: dateString)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM"
        let requiredDate = dateFormatter2.string(from: date!)
        
        return requiredDate
    }
    
    func convertMinToHour(min: Int) -> String {
        let hours: Int = min / 60
        let mins: Int = min % 60
        return "\(hours)h  \(mins)m"
    }
    
    
    func configureSearchCell(model: SearchResults) {

        switch model.mediaType {
        
        case .movie:
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(model.posterPath ?? "")")
            showNameLabel.text = model.title
            posterImageView.sd_setImage(with: url, completed: nil)
            rateLabel.text = "\(model.voteAverage ?? 0)"
            dateLabel.text = model.mediaType.rawValue
            starImageView.alpha = 1
            rateLabelLeading.constant = 35
        case .tv:
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(model.posterPath ?? "")")
            showNameLabel.text = model.originalName
            posterImageView.sd_setImage(with: url, completed: nil)
            rateLabel.text = "\(model.voteAverage ?? 0)"
            dateLabel.text = model.mediaType.rawValue
            starImageView.alpha = 1
            rateLabelLeading.constant = 35
        case .person:
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(model.profilePath ?? "")")
            showNameLabel.text = model.name
            posterImageView.sd_setImage(with: url, completed: nil)
            rateLabel.text = model.knownForDepartment
            dateLabel.text = model.mediaType.rawValue
            starImageView.alpha = 0
            rateLabelLeading.constant = 15
        }
    }
    
}
