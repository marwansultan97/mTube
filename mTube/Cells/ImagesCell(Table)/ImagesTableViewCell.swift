//
//  ImagesTableViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/19/21.
//

import UIKit
import ChameleonFramework

class ImagesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{


    @IBOutlet weak var imagesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var separatorLine: UIView!
    
    let collectionViewCellIdentifier = "ImagesCollectionViewCell"
    
    var showImages: [Backdrop] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        configureCollectionView()
        
    }
    
    func configureUI() {
        imagesLabel.textColor = FlatOrange()
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageAspectRatio = CGFloat(showImages[indexPath.row].aspectRatio)
        let height: CGFloat = 200
        let width: CGFloat = height * imageAspectRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! ImagesCollectionViewCell
        cell.configureShowImages(model: showImages[indexPath.row])
        print(cell.layer.frame.width)
        return cell
    }
    
}
