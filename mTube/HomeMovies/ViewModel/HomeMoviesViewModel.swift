//
//  HomeMoviesViewModel.swift
//  mTube
//
//  Created by Marwan Osama on 2/15/21.
//

import UIKit
import Combine
import Alamofire

class HomeMoviesViewModel {
    
    let networkService = NetworkService.shared
    
    var group: DispatchGroup?
    
    
    @Published var mostPopularMovies: [MoviesResult] = []
    @Published var topRatedMovies: [MoviesResult] = []
    @Published var upcomingMovies: [MoviesResult] = []
    @Published var trendingMovies: [MoviesResult] = []
    @Published var contentAlpha: CGFloat = 0
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    @Published var upcomingDate: String = ""
    @Published var genres: [Genre] = []
    
    

    
    
    func getMostPopularMovies() {
        
        let url = Endpoints.moviesList(sorting: .popular, page: 1).url
        self.isLoading = true
        self.contentAlpha = 0
        self.group = DispatchGroup()
        self.group?.enter()
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0) {
            self.networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: Movie?, err) in
                guard let self = self else { return }
                if let err = err {
                    print(err)
                    self.isLoading = false
                } else {
                    guard let result = result else { return }
                    self.mostPopularMovies = result.results
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
    
    func getTopRatedMovies() {
        let url = Endpoints.moviesList(sorting: .topRated, page: 1).url
        self.group?.enter()
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: Movie?, err) in
            guard let self = self else { return }
            if let err = err {
                print(err)
                self.isLoading = false
            } else {
                guard let result = result?.results else { return }
                self.topRatedMovies = result
                self.group?.leave()
            }
        }
        
    }
    
    
    func getUpcomingMovies() {
        self.group?.enter()
        let url = Endpoints.moviesList(sorting: .upcoming, page: 1).url
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: Movie?, err) in
            guard let self = self else { return }
            if let err = err {
                print(err)
                self.isLoading = false
            } else {
                guard let result = result else { return }
                self.upcomingMovies = result.results
                self.upcomingDate = result.dates!.minimum
                self.group?.leave()
            }
        }
        
    }
    
    func getTrendingMovies() {
        let url = Endpoints.trending(classification: .movies, page: 1).url
        self.group?.enter()
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: Movie?, err) in
            guard let self = self else { return }
            if let err = err {
                print("TRENDING: \(err)")
                self.isLoading = false
            } else {
                guard let result = result else { return }
                self.trendingMovies = result.results
                self.group?.leave()
            }
        }
    }
    
    func getGenres() {
        let url = Endpoints.genres.url
        self.group?.enter()
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: Genres?, err) in
            guard let self = self else { return }
            if let err = err {
                print("Genres: \(err)")
                self.isLoading = false
            } else {
                guard let result = result else { return }
                self.genres = result.genres
                self.group?.leave()
            }
        }
        
    }

    
    
    
    
    
    
    
    
    
    
}



