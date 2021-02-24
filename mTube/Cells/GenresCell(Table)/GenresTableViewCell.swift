//
//  GenresTableViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/15/21.
//

import UIKit
import ChameleonFramework

class GenresTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var separatorLine: UIView!
    
    let collectionViewCellIdentifier = "GenresCollectionViewCell"
    
    var genres = [Genre]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var cellSelection: ((_ id: Int, _ name: String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        configureCollectionView()
    }
    
    func configureUI() {
        genreLabel.textColor = FlatOrange().lighten(byPercentage: 0.5)
        contentView.backgroundColor = UIColor.flatBlue().darken(byPercentage: 0.45)
        separatorLine.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
    }
    
    func configureCollectionView() {
        collectionView.apply {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: collectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - CollectionView Configurations
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! GenresCollectionViewCell
        let model = genres[indexPath.row]
        cell.configureCell(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genreSelected = genres[indexPath.row]
        cellSelection?(genreSelected.id, genreSelected.name)
    }
}
