//
//  PosterCollectionViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/16/21.
//

import UIKit
import SDWebImage

class PosterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var videoTypeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func configureCell(movie: MoviesResult?, tv: TvResult?) {
        if let movie = movie {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(movie.posterPath)")
            posterImageView.sd_setImage(with: url, completed: nil)
            posterNameLabel.text = movie.originalTitle
            videoTypeLabel.text = "Official Trailer"
        }
        
        if let tv = tv {
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(tv.posterPath)")
            posterImageView.sd_setImage(with: url, completed: nil)
            posterNameLabel.text = tv.originalName
            videoTypeLabel.text = "Official Trailer"
        }
        
        
    }

}
