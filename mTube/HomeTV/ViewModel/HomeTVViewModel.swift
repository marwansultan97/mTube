//
//  HomeTVViewModel.swift
//  mTube
//
//  Created by Marwan Osama on 2/16/21.
//

import UIKit
import Combine
import Alamofire

class HomeTVViewModel {
    
    let networkService = NetworkService.shared
    
    var group: DispatchGroup?
    
    
    @Published var mostPopularTV: [TvResult] = []
    @Published var topRatedTV: [TvResult] = []
    @Published var trendingTV: [TvResult] = []
    @Published var contentAlpha: CGFloat = 0
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    @Published var upcomingDate: String = ""
    
    
    
    func getMostPopularTV() {
        
        let url = Endpoints.tvList(sorting: .popular, page: 1).url
        self.isLoading = true
        self.contentAlpha = 0
        self.group = DispatchGroup()
        self.group?.enter()
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()) {
            self.networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: TV?, err) in
                guard let self = self else { return }
                if let err = err {
                    print("MostPopular: \(err)")
                    self.isLoading = false
                } else {
                    guard let result = result else { return }
                    self.mostPopularTV = result.results
                    self.group?.leave()
                }
                
                
                self.group?.notify(queue: .main) {
                    self.contentAlpha = 1
                    self.isLoading = false
                    print("Done")
                }
            }
        }
  
    }
    
    func getTopRatedTV() {
        let url = Endpoints.tvList(sorting: .topRated, page: 1).url
        self.group?.enter()
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: TV?, err) in
            guard let self = self else { return }
            if let err = err {
                print("TopRated: \(err)")
                self.isLoading = false
            } else {
                guard let result = result else { return }
                self.topRatedTV = result.results
                self.group?.leave()
            }
        }
        
    }
    
    func getTrendingTV() {
        let url = Endpoints.trending(classification: .tv, page: 1).url
        self.group?.enter()
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: TV?, err) in
            guard let self = self else { return }
            if let err = err {
                print("Trending TV \(err)")
                self.isLoading = false
            } else {
                guard let result = result else { return }
                self.trendingTV = result.results
                self.group?.leave()
            }
        }
    }
    
    
    
    
}
