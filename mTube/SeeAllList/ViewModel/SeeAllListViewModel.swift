//
//  SeeAllListViewModel.swift
//  mTube
//
//  Created by Marwan Osama on 2/20/21.
//

import UIKit
import Alamofire
import Combine

class SeeAllListViewModel {
    
    var isPaginating: Bool = false
    var page = 1
    let networkService = NetworkService.shared
    
    @Published var movieList: [MoviesResult] = []
    @Published var tvList: [TvResult] = []
    @Published var genreList: [MoviesResult] = []
    @Published var contentAlpha: CGFloat = 0
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    
    func getList(classification: Classifications, sorting: ShowSorting, pagination: Bool) {
        if pagination {
            isPaginating = true
            page += 1
        } else {
            contentAlpha = 0
            isLoading = true
            page = 1
        }
        let url = Endpoints.seeAllList(classification: classification, sorting: sorting, page: page).url
        switch classification {
        case .movies:
            networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: Movie?, err) in
                guard let self = self else { return }
                self.isLoading = false
                print("Getting data")
                if let err = err {
                    print("List \(err)")
                } else {
                    guard let result = result else { return }
                    if pagination {
                        self.isPaginating = false
                        self.movieList.append(contentsOf: result.results)
                    } else {
                        self.movieList = result.results
                        self.contentAlpha = 1
                    }
                    
                }
            }

        case .tv:
            networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: TV?, err) in
                guard let self = self else { return }
                self.isLoading = false
                print("Getting data")
                if let err = err {
                    print("List \(err)")
                } else {
                    guard let result = result else { return }
                    if pagination {
                        self.isPaginating = false
                        self.tvList.append(contentsOf: result.results)
                    } else {
                        self.tvList = result.results
                        self.contentAlpha = 1
                    }
                    
                }
            }
        case .person:
            break
        }
        
    }
    
    func getGenreList(genreID: Int ,pagination: Bool) {
        if pagination {
            isPaginating = true
            page += 1
        } else {
            contentAlpha = 0
            isLoading = true
            page = 1
        }
        let url = Endpoints.discover(classification: .movies, sorting: .popularityDesc, releaseYear: nil, page: page, genre: genreID).url
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: Movie?, err) in
            guard let self = self else { return }
            self.isLoading = false
            if let err = err {
                print("Genre List \(err)")
            } else {
                guard let result = result else { return }
                if pagination {
                    self.isPaginating = false
                    self.genreList.append(contentsOf: result.results)
                } else {
                    self.genreList = result.results
                    self.contentAlpha = 1
                }
            }
        }
    }
    
    
}
