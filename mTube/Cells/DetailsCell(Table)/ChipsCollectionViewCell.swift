//
//  ChipsCollectionViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/17/21.
//

import UIKit
import ChameleonFramework

class ChipsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        genreNameLabel.textColor = FlatOrange()
        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.white.cgColor
    }

}
