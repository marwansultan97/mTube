//
//  SearchViewModel.swift
//  mTube
//
//  Created by Marwan Osama on 2/21/21.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let page: Int
    let results: [SearchResults]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct SearchResults: Codable {
    let backdropPath: String?
    let firstAirDate: String?
    let genreIDS: [Int]?
    let id: Int
    let mediaType: MediaType
    let name: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let adult: Bool?
    let originalTitle: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let gender: Int?
    let knownFor: [SearchResults]?
    let knownForDepartment: String?
    let profilePath: String?

    

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id = "id"
        case mediaType = "media_type"
        case name = "name"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case adult = "adult"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case gender = "gender"
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"

    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case person = "person"
    case tv = "tv"
}


