//
//  PersonDetailsViewModel.swift
//  mTube
//
//  Created by Marwan Osama on 2/22/21.
//

import UIKit
import Alamofire
import Combine

class PersonDetailsViewModel {
    
    let networkService = NetworkService.shared
    
    
    
    @Published var personDetails: PersonDetails?
    @Published var personImages: [ProfileImage] = []
    @Published var personFilmography: [Filmography] = []
    @Published var errorMessage: String?
    
    
    func getPersonDetails(id: Int) {
        
        let url = Endpoints.showDetails(classification: .person, id: id).url

        
        self.networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: PersonDetails?, err) in
            guard let self = self else { return }
            if let err = err {
                print("SHOW DETAILS: \(err)")
            } else {
                guard let result = result else { return }
                self.personDetails = result
            }
        }
    }
    
    func getPersonImages(id: Int) {
        let url = Endpoints.showImages(classification: .person, id: id).url
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: PersonImages?, err) in
            guard let self = self else { return }
            if let err = err {
                print("SHOW IMAGES: \(err)")
            } else {
                guard let result = result?.profiles else { return }
                self.personImages.append(contentsOf: result.prefix(20))
            }
        }

    }
    
    func getPersonFilmography(id: Int) {
        let url = Endpoints.personFilmography(id: id).url
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: PersonFilmography?, err) in
            guard let self = self else { return }
            if let err = err {
                print("SHOW CAST: \(err)")
            } else {
                guard let result = result?.cast else { return }
                self.personFilmography = result
            }
        }
    }
    
    
    
    
    
    
}
