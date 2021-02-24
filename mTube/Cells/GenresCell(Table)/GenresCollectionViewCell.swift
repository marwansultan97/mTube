//
//  GenresCollectionViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/15/21.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var opacityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    func configureUI() {
        genreImageView.layer.cornerRadius = 10
        opacityView.layer.cornerRadius = 10
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
    }
    
    func configureCell(model: Genre) {
        genreNameLabel.text = model.name
        genreImageView.image = UIImage(named: model.name)
    }

}
