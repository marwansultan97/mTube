//
//  PersonDetailsViewController.swift
//  mTube
//
//  Created by Marwan Osama on 2/22/21.
//

import UIKit
import Combine
import ChameleonFramework

class PersonDetailsViewController: UIViewController {

    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var id: Int?
    let personImagesCellIdent = "PersonImagesCollectionViewCell"
    let detailsCellIdent = "DetailsTableViewCell"
    let cardsCellIdent = "CardsTableViewCell"
    
    var subscription = Set<AnyCancellable>()
    lazy var viewModel: PersonDetailsViewModel = {
        return PersonDetailsViewModel()
    }()
    
    var personImages: [ProfileImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var personDetails: PersonDetails? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var personFilmography: [Filmography] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        setSubscription()
        configureTableView()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigationApperance = UINavigationBarAppearance()
        navigationApperance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationApperance.backgroundColor = UIColor.blue.darken(byPercentage: 0.9)
        navigationItem.standardAppearance = navigationApperance
        navigationItem.compactAppearance = navigationApperance
        navigationItem.scrollEdgeAppearance = navigationApperance
    }
    
    override func viewDidLayoutSubviews() {
        collectionViewHeight.constant = self.view.frame.height / 3.3
    }
    
    func setSubscription() {
        subscription = [
            viewModel.$personDetails.assign(to: \.personDetails, on: self),
            viewModel.$personImages.assign(to: \.personImages, on: self),
            viewModel.$personFilmography.assign(to: \.personFilmography, on: self)
        ]
        
        viewModel.getPersonImages(id: id!)
        viewModel.getPersonDetails(id: id!)
        viewModel.getPersonFilmography(id: id!)
    }
    
    func configureTableView() {
        tableView.apply {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
            $0.separatorStyle = .none
            $0.register(UINib(nibName: detailsCellIdent, bundle: nil), forCellReuseIdentifier: detailsCellIdent)
            $0.register(UINib(nibName: cardsCellIdent, bundle: nil), forCellReuseIdentifier: cardsCellIdent)
        }

    }
    
    func configureCollectionView() {
        collectionView.apply {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.register(UINib(nibName: personImagesCellIdent, bundle: nil), forCellWithReuseIdentifier: personImagesCellIdent)
        }
    }
    
    func goToShowDetail(id: Int) {
        let vc = UIStoryboard(name: "ShowDetails", bundle: nil).instantiateInitialViewController() as? ShowDetailsViewController
        vc?.id = id
        vc?.classification = .movies
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    

}

extension PersonDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellIdent, for: indexPath) as! DetailsTableViewCell
            guard let personDetails = personDetails else { return cell }
            cell.configureCell(movie: nil, tv: nil, person: personDetails)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardsCellIdent, for: indexPath) as! CardsTableViewCell
            cell.seeAllButton.alpha = 0
            cell.cardCellOptions = .personFilmography
            cell.personFilmography = self.personFilmography
            let boldAtt = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
            let mediumAtt = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.7)]
            let boldAttributes = NSMutableAttributedString(string: "Filmography\n", attributes: boldAtt)
            let mediumAttributes = NSMutableAttributedString(string: "Known for", attributes: mediumAtt)
            boldAttributes.append(mediumAttributes)
            cell.categoryLabel.attributedText = boldAttributes
            
            cell.cellSelection = { [weak self] (movie, tv, filmography) in
                guard let self = self else { return }
                guard let filmography = filmography else { return }
                self.goToShowDetail(id: filmography.id)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 360 : 380
    }
    
    
    
}


extension PersonDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personImagesCellIdent, for: indexPath) as! PersonImagesCollectionViewCell
        let photo = personImages[indexPath.row]
        let url = URL(string: "https://image.tmdb.org/t/p/w200/\(photo.filePath)")
        cell.personImageView.sd_setImage(with: url, completed: nil)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = personImages[indexPath.row]
        let height: Double = Double(collectionViewHeight.constant - 17)
        let width: Double = height * photo.aspectRatio
        return CGSize(width: width, height: height)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
    }
    
    
}
