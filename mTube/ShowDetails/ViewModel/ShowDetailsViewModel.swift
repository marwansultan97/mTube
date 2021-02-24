//
//  ShowDetailsViewModel.swift
//  mTube
//
//  Created by Marwan Osama on 2/17/21.
//

import UIKit
import Combine
import Alamofire

class ShowDetailsViewModel {
    
    let networkService = NetworkService.shared
        
    
    @Published var movieDetails: MoviesDetails?
    @Published var tvDetails: TvDetails?
    @Published var showImages: [Backdrop] = []
    @Published var showVideos: Video?
    @Published var showCast: [Cast] = []
    @Published var errorMessage: String?
    
    
    func getShowDetails(classification: Classifications, id: Int) {
        
        let url = Endpoints.showDetails(classification: classification, id: id).url
    
        
        switch classification {
        case.movies:
            self.networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: MoviesDetails?, err) in
                guard let self = self else { return }
                if let err = err {
                    print("SHOW DETAILS: \(err)")
                } else {
                    guard let result = result else { return }
                    self.movieDetails = result
                }

            }
        case.tv:
            self.networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: TvDetails?, err) in
                guard let self = self else { return }
                if let err = err {
                    print("SHOW DETAILS: \(err)")
                } else {
                    guard let result = result else { return }
                    self.tvDetails = result
                }
            }
        case .person:
            break
        }
        
  
    }
    
    func getShowImages(classification: Classifications, id: Int) {
        let url = Endpoints.showImages(classification: classification, id: id).url

        switch classification {
        
        case .movies, .tv :
            networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: ShowImages?, err) in
                guard let self = self else { return }
                if let err = err {
                    print("SHOW IMAGES: \(err)")
                } else {
                    guard let result = result?.backdrops else { return }
                    self.showImages.append(contentsOf: result.prefix(20))
                }
            }
            
        case .person:
            break
        }
        
        
    }
    
    
    func getShowCast(classification: Classifications, id: Int) {
        let url = Endpoints.showCast(classification: classification, id: id).url
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: ShowCast?, err) in
            guard let self = self else { return }
            if let err = err {
                print("SHOW CAST: \(err)")
            } else {
                guard let result = result?.cast else { return }
                self.showCast.append(contentsOf: result.prefix(20))
            }
        }
        
    }
    
    func getShowVideo(classification: Classifications, id: Int) {
        let url = Endpoints.showVideo(classification: classification, id: id).url
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: ShowVideos?, err) in
            guard let self = self else { return }
            if let err = err {
                print("SHOW CAST: \(err)")
            } else {
                guard let result = result?.results.first else { return }
                self.showVideos = result
            }
        }
        
    }
    
    
    
 
}
