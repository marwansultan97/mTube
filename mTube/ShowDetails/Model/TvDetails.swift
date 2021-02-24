//
//  tvDetails.swift
//  mTube
//
//  Created by Marwan Osama on 2/18/21.
//

import Foundation

// MARK: - TvDetails
struct TvDetails: Codable {
    let backdropPath: String?
    let createdBy: [CreatedBy]
    let episodeRunTime: [Int]
    let firstAirDate: String
    let genres: [ShowGenres]
    let homepage: String?
    let id: Int
    let inProduction: Bool?
    let languages: [String]
    let lastAirDate: String?
    let lastEpisodeToAir: TEpisodeToAir?
    let name: String
    let nextEpisodeToAir: TEpisodeToAir?
    let networks: [Network]?
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let originCountry: [String]?
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [Network]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let type: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres = "genres"
        case homepage = "homepage"
        case id = "id"
        case inProduction = "in_production"
        case languages = "languages"
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name = "name"
        case nextEpisodeToAir = "next_episode_to_air"
        case networks = "networks"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons = "seasons"
        case spokenLanguages = "spoken_languages"
        case status = "status"
        case tagline = "tagline"
        case type = "type"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int?
    let creditID: String?
    let name: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case creditID = "credit_id"
        case name = "name"
        case gender = "gender"
        case profilePath = "profile_path"
    }
}


// MARK: - TEpisodeToAir
struct TEpisodeToAir: Codable {
    let airDate: String?
    let episodeNumber: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let productionCode: String?
    let seasonNumber: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Network
struct Network: Codable {
    let name: String?
    let id: Int?
    let logoPath: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}



// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

