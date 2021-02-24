//
//  TrailerTableViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/23/21.
//

import UIKit
import youtube_ios_player_helper

class TrailerTableViewCell: UITableViewCell, YTPlayerViewDelegate {
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    
    var playerIsReadyClosure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurePlayerView()
        configureUI()
        
    }
    
    func configureUI() {
        loadingLabel.alpha = 1
        contentView.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
    }
    
    func configurePlayerView() {
        playerView.apply {
            $0.alpha = 0
            $0.delegate = self
            $0.setPlaybackQuality(.auto)
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(video: Video) {
        playerView.load(withVideoId: video.key)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerIsReadyClosure?()
    }
    
}
