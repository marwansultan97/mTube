//
//  ShowVideos.swift
//  mTube
//
//  Created by Marwan Osama on 2/17/21.
//

import Foundation

// MARK: - ShowVideos
struct ShowVideos: Codable {
    let id: Int
    let results: [Video]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case results = "results"
    }
}

// MARK: - Result
struct Video: Codable {
    let id: String
    let iso639_1: String
    let iso3166_1: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key = "key"
        case name = "name"
        case site = "site"
        case size = "size"
        case type = "type"
    }
}
