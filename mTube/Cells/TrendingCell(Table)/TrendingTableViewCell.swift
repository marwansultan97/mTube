//
//  TrendingTableViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/16/21.
//

import UIKit


class TrendingTableViewCell: UITableViewCell {

    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var posterCollectionView: UICollectionView!
    @IBOutlet weak var lineSeparator: UIView!
    
    let videoCellIdentifier = "VideoCollectionViewCell"
    let posterCellIdentifier = "PosterCollectionViewCell"
    
    var movieModels: [MoviesResult] = [] {
        didSet {
            videoCollectionView.reloadData()
            posterCollectionView.reloadData()
        }
    }
    
    var tvModels: [TvResult] = [] {
        didSet {
            videoCollectionView.reloadData()
            posterCollectionView.reloadData()
        }
    }
    
    var classification: Classifications?
    var cellSelection: (( _ movie: MoviesResult?, _ tv: TvResult?)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        configureViewCollectionView()
        configurePosterCollectionView()
    }
    
    func configureUI() {
        contentView.backgroundColor = UIColor.flatBlue().darken(byPercentage: 0.45)
        lineSeparator.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
    }
    
    func configureViewCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.apply {
            $0.scrollDirection = .horizontal
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 230)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0
            $0.sectionInset = .zero
        }
        
        videoCollectionView.apply {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: videoCellIdentifier, bundle: nil), forCellWithReuseIdentifier: videoCellIdentifier)
            $0.setCollectionViewLayout(layout, animated: true)
            $0.decelerationRate = .fast
        }
        
    }
    
    func configurePosterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.apply {
            $0.scrollDirection = .horizontal
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 150)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        posterCollectionView.apply {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: posterCellIdentifier, bundle: nil), forCellWithReuseIdentifier: posterCellIdentifier)
            $0.setCollectionViewLayout(layout, animated: true)
            $0.isUserInteractionEnabled = false
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func snapToCenter() {
        let point = convert(center, to: videoCollectionView)
        guard let centerIndexPath = videoCollectionView.indexPathForItem(at: point) else {return}
        videoCollectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
        posterCollectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
    }
    
}

//MARK: - CollectionView Configurations
extension TrendingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch classification {
        case .movies:
            return movieModels.count
        case.tv:
            return tvModels.count
        case .none, .person:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videoCollectionView {
            let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: videoCellIdentifier, for: indexPath) as! VideoCollectionViewCell
            switch classification {
            case .movies:
                let model = movieModels[indexPath.row]
                cell.configureCell(movie: model, tv: nil)
                
                cell.playButtonTapped = { [weak self] in
                    self?.cellSelection?(model, nil)
                }
                
            case .tv:
                let model = tvModels[indexPath.row]
                cell.configureCell(movie: nil, tv: model)
                
                cell.playButtonTapped = { [weak self] in
                    self?.cellSelection?(nil, model)
                }
                
            case .none, .person:
                break
            }
            
            
            return cell
        } else {
            let cell = posterCollectionView.dequeueReusableCell(withReuseIdentifier: posterCellIdentifier, for: indexPath) as! PosterCollectionViewCell
            switch classification {
            case .movies:
                let movie = movieModels[indexPath.row]
                cell.configureCell(movie: movie, tv: nil)
                
            case .tv:
                let tv = tvModels[indexPath.row]
                cell.configureCell(movie: nil, tv: tv)
            case .none, .person:
                break
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch classification {
        case.movies:
            let movie = movieModels[indexPath.row]
            cellSelection?(movie, nil)
        case.tv:
            let tv = tvModels[indexPath.row]
            cellSelection?(nil, tv)
        case .none, .person:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == videoCollectionView {
            let pointX = scrollView.contentOffset.x
            let pointY = scrollView.contentOffset.y
            posterCollectionView.scrollRectToVisible(CGRect(x: pointX, y: pointY, width: posterCollectionView.frame.width, height: posterCollectionView.frame.height), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == videoCollectionView {
            snapToCenter()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == videoCollectionView {
            if !decelerate {
                snapToCenter()
            }
        }
    }
    
    
}

