//
//  Endpoints.swift
//  mTube
//
//  Created by Marwan Osama on 2/15/21.
//

import Foundation

// https://api.themoviedb.org/3/person/287/movie_credits?api_key=5c9e2b0796e129213c54a9f80e60ec9f
enum Endpoints {
    
    case discover(classification: Classifications, sorting: DiscoverSorting, releaseYear: Int?, page: Int, genre: Int?)
    case moviesList(sorting: ShowSorting, page: Int)
    case genres
    case seeAllList(classification: Classifications, sorting: ShowSorting, page: Int)
    case tvList(sorting: ShowSorting, page: Int)
    case trending(classification: Classifications, page: Int)
    case showDetails(classification: Classifications, id: Int)
    case showImages(classification: Classifications, id: Int)
    case showVideo(classification: Classifications, id: Int)
    case showCast(classification: Classifications, id: Int)
    case personFilmography(id: Int)
    case search(query: String, page: Int)
    
    var url: String {
        let apiBody = "https://api.themoviedb.org/3"
        let apiKey = "5c9e2b0796e129213c54a9f80e60ec9f"
        
        
        switch self {
        
        case.discover(let classification, let sorting, let releaseYear, let page, let genre):
            var url = apiBody + "/discover/" + classification.rawValue + "?api_key=\(apiKey)" + "&sort_by=\(sorting.rawValue)" + "&page=\(page)"
            if let releaseYear = releaseYear {
                url += "&primary_release_year=\(releaseYear)"
            }
            if let genre = genre {
                url += "&with_genres=\(genre)"
            }
            return url
            
        
        case .moviesList(let sorting, let page):
            return apiBody + "/movie/" + "\(sorting.rawValue)" + "?api_key=\(apiKey)" + "&page=\(page)"
            
        case .genres:
            return apiBody + "/genre/movie/list" + "?api_key=\(apiKey)"
            
        case .tvList(let sorting, let page):
            return apiBody + "/tv/" + "\(sorting.rawValue)" + "?api_key=\(apiKey)" + "&page=\(page)"
            
        case .trending(let classification, let page):
            return apiBody + "/trending/" + classification.rawValue + "/week" + "?api_key=\(apiKey)" + "&page=\(page)"
            
        case .showDetails(let classification, let id):
            return apiBody + "/\(classification.rawValue)/" + "\(id)" + "?api_key=\(apiKey)"
            
        case .showImages(let classification, let id):
            return apiBody + "/\(classification.rawValue)/" + "\(id)" + "/images" + "?api_key=\(apiKey)"
            
        case .showCast(classification: let classification, id: let id):
            return apiBody + "/\(classification.rawValue)/" + "\(id)" + "/credits" + "?api_key=\(apiKey)"
            
        case .showVideo(classification: let classification, id: let id):
            return apiBody + "/\(classification.rawValue)/" + "\(id)" + "/videos" + "?api_key=\(apiKey)"
            
        case .seeAllList(classification: let classification, sorting: let sorting, page: let page):
            return apiBody + "/\(classification.rawValue)/" + "\(sorting.rawValue)" + "?api_key=\(apiKey)" + "&page=\(page)"
            
        case .search(let query, let page):
            return apiBody + "/search/" + "multi" + "?api_key=\(apiKey)" + "&page=\(page)" + "&query=\(query)"
            
        case .personFilmography(let id):
            return apiBody + "/person/" + "\(id)" + "/movie_credits" + "?api_key=\(apiKey)"
        }
    }
    
    
}


enum Classifications: String {
    case movies = "movie"
    case tv = "tv"
    case person = "person"
}

enum DiscoverSorting: String {
    
    case popularityDesc = "popularity.desc"
    case popularityAsc = "popularity.asc"
    case releaseDateDesc = "release_date.desc"
    case releaseDateAsc = "release_date.asc"
    case revenueDesc = "revenue.desc"
    case revenueAsc = "revenue.asc"
    
}

enum ShowSorting: String {
    
    case topRated = "top_rated"
    case popular = "popular"
    case upcoming = "upcoming" // for movies only
    case tvOnAir = "tv_on_air" // for tv shows only (gets you a list of tvShows that has an episode on air for next 7 days)
    
}
