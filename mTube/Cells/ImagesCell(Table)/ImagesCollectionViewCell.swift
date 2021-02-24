//
//  ImagesCollectionViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/19/21.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    func configureShowImages(model: Backdrop) {
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(model.filePath)")
        photoImageView.sd_setImage(with: url, completed: nil)
        
    }

}
