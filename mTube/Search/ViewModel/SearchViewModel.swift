//
//  SearchViewModel.swift
//  mTube
//
//  Created by Marwan Osama on 2/21/21.
//

import UIKit
import Combine
import Alamofire

class SearchViewModel {
    
    var isPaginating: Bool = false
    var page = 1
    var totalResults: Int?
    
    let networkService = NetworkService.shared
    
    @Published var results: [SearchResults] = []
    @Published var contentAlpha: CGFloat = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func getSearchResults(query: String, pagination: Bool) {
        if pagination {
            isPaginating = true
            page += 1
        } else {
            isLoading = true
            contentAlpha = 0
            errorMessage = ""
            page = 1
        }
        let trimmedQuery = query.replacingOccurrences(of: " ", with: "@")
        let url = Endpoints.search(query: trimmedQuery, page: page).url
        print(url)
        networkService.getData(url: url, method: .get, headers: nil, parameters: nil, encoding: JSONEncoding.default) { [weak self] (result: SearchResult?, err) in
            guard let self = self else { return }
            self.isLoading = false
            if let err = err {
                print("SEARCH \(err)")
                self.errorMessage = "No Results Matches your search..."
            } else {
                guard let result = result else { return }
                if pagination {
                    self.isPaginating = false
                    self.results.append(contentsOf: result.results)
                } else {
                    if result.results.isEmpty {
                        print("empty")
                        self.contentAlpha = 0
                        self.errorMessage = "No Results Matches your search..."
                    } else {
                        self.errorMessage = ""
                        self.results = result.results
                        self.totalResults = result.totalResults
                        self.contentAlpha = 1
                        print(self.totalResults!)
                    }
                    
                }
            }
        }
    }
    
    
    
    
    
    
}
