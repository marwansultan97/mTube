//
//  VideoCollectionViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/16/21.
//

import UIKit
import SDWebImage


class VideoCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var playButtonTapped: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        playButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func configureCell(movie: MoviesResult?, tv: TvResult?) {
        if let movie = movie {
            let url = URL(string: "https://image.tmdb.org/t/p/w300/\(movie.backdropPath ?? "")")
            videoImageView.sd_setImage(with: url, completed: nil)
        }
        
        if let tv = tv {
            let url = URL(string: "https://image.tmdb.org/t/p/w300/\(tv.backdropPath ?? "")")
            videoImageView.sd_setImage(with: url, completed: nil)
        }
        
    }
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        playButtonTapped?()
    }
    
}
