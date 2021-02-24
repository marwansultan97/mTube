//
//  HomeViewController.swift
//  mTube
//
//  Created by Marwan Osama on 2/13/21.
//

import UIKit
import XLPagerTabStrip
import ChameleonFramework

class HomeViewController: ButtonBarPagerTabStripViewController {

    
    override func viewDidLoad() {
        configureTapsStyle()
        super.viewDidLoad()
        title = "Home"
        configureNavBar()
        view.backgroundColor = UIColor.gray.darken(byPercentage: 0.5)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigationApperance = UINavigationBarAppearance()
        navigationApperance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationApperance.backgroundColor = UIColor.blue.darken(byPercentage: 0.85)
        navigationItem.standardAppearance = navigationApperance
        navigationItem.compactAppearance = navigationApperance
        navigationItem.scrollEdgeAppearance = navigationApperance
    }
    
    func configureNavBar() {
        let button = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goToSearch))
        navigationItem.rightBarButtonItem = button
    }
    
    func configureTapsStyle() {
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.selectedBarHeight = 2.5
        settings.style.selectedBarBackgroundColor = FlatOrange().lighten(byPercentage: 0.5)
        settings.style.buttonBarItemBackgroundColor = UIColor.blue.darken(byPercentage: 0.85)
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    @objc func goToSearch() {
        let searchVC = UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController()
        searchVC?.title = "Search"
        self.navigationController?.pushViewController(searchVC!, animated: true)
    }
    
    
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let movies = UIStoryboard(name: "HomeMovies", bundle: nil).instantiateInitialViewController()
        let tv = UIStoryboard(name: "HomeTV", bundle: nil).instantiateInitialViewController()
        return [movies!,tv!]
    }
    

}
