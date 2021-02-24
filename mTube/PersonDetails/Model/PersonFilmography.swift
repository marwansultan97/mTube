//
//  PersonFilmography.swift
//  mTube
//
//  Created by Marwan Osama on 2/22/21.
//

import Foundation

// MARK: - PersonFilmography
struct PersonFilmography: Codable {
    let cast: [Filmography]
    let crew: [Filmography]
    let id: Int

    enum CodingKeys: String, CodingKey {
        case cast = "cast"
        case crew = "crew"
        case id = "id"
    }
}

// MARK: - Cast
struct Filmography: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String?
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double?
    let character: String?
    let creditID: String
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity = "popularity"
        case character = "character"
        case creditID = "credit_id"
        case order = "order"
        case department = "department"
        case job = "job"
    }
}

