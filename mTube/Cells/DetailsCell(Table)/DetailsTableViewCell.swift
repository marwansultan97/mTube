//
//  DetailsTableViewCell.swift
//  mTube
//
//  Created by Marwan Osama on 2/17/21.
//

import UIKit

class DetailsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var line1topConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var dateRunTimeLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var starImageHeight: NSLayoutConstraint!
    
    var genres: [ShowGenres] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let cellIdentifier = "ChipsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        configureCollectionView()
        
    }
    
    func configureUI() {
        contentView.backgroundColor = UIColor.flatBlue().darken(byPercentage: 0.45)
        line3.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        showNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.apply {
            $0.scrollDirection = .horizontal
            $0.itemSize = UICollectionViewFlowLayout.automaticSize
            $0.estimatedItemSize = CGSize(width: 70, height: 30)
            $0.minimumLineSpacing = 5
            $0.minimumInteritemSpacing = 0
            $0.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
        
        collectionView.apply {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.setCollectionViewLayout(layout, animated: true)
            $0.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(movie: MoviesDetails?, tv: TvDetails?, person: PersonDetails?) {
        if let movie = movie {
            showNameLabel.text = movie.originalTitle
            dateRunTimeLabel.text = convertDate(dateString: movie.releaseDate) + " " + convertMinToHour(min: movie.runtime)
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(movie.posterPath)")
            showImageView.sd_setImage(with: url, completed: nil)
            overViewLabel.text = movie.overview
            overViewLabel.numberOfLines = 5
            voteAverageLabel.text = "\(movie.voteAverage)/10"
            voteCountLabel.text = "\(movie.voteCount)"
            collectionViewHeight.constant = 50
            starImageHeight.constant = 30
            line2.alpha = 0.7
            imageViewWidth.constant = 100
            imageViewHeight.constant = 160
            line1topConstraint.constant = 75
        }
        
        if let tv = tv {
            showNameLabel.text = tv.originalName
            dateRunTimeLabel.text = convertDate(dateString: tv.firstAirDate) + " " + convertMinToHour(min: tv.episodeRunTime.first ?? 0)
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(tv.posterPath)")
            showImageView.sd_setImage(with: url, completed: nil)
            overViewLabel.text = tv.overview
            overViewLabel.numberOfLines = 5
            voteAverageLabel.text = "\(tv.voteAverage)/10"
            voteCountLabel.text = "\(tv.voteCount)"
            collectionViewHeight.constant = 50
            starImageHeight.constant = 30
            line2.alpha = 0.7
            imageViewWidth.constant = 100
            imageViewHeight.constant = 160
            line1topConstraint.constant = 75
        }
        
        if let person = person {
            showNameLabel.text = person.name
            let url = URL(string: "https://image.tmdb.org/t/p/w200/\(person.profilePath)")
            showImageView.sd_setImage(with: url, completed: nil)
            overViewLabel.text = person.biography
            overViewLabel.numberOfLines = 10
            voteCountLabel.text = "Place of birth: \(person.placeOfBirth)"
            voteAverageLabel.text = "Born in: \(convertDate2(dateString: person.birthday))"
            collectionViewHeight.constant = 0
            starImageHeight.constant = 0
            line2.alpha = 0
            dateRunTimeLabel.text = ""
            imageViewWidth.constant = 120
            imageViewHeight.constant = 210
            line1topConstraint.constant = 75
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
    
    func convertDate2(dateString: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter1.date(from: dateString)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MMM yyyy"
        let requiredDate = dateFormatter2.string(from: date!)
        
        return requiredDate
    }

    
    func convertMinToHour(min: Int) -> String {
        let hours: Int = min / 60
        let mins: Int = min % 60
        return "\(hours)h \(mins)m"
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChipsCollectionViewCell
        cell.genreNameLabel.text = genres[indexPath.row].name
        return cell
    }
    
}
