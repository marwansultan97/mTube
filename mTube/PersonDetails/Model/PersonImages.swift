//
//  PersonImages.swift
//  mTube
//
//  Created by Marwan Osama on 2/22/21.
//

import Foundation

// MARK: - PersonImages
struct PersonImages: Codable {
    let id: Int
    let profiles: [ProfileImage]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case profiles = "profiles"
    }
}

// MARK: - Profile
struct ProfileImage: Codable {
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let iso639_1: Double?
    let voteAverage: Double
    let voteCount: Int
    let width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height = "height"
        case iso639_1 = "iso_639_1"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width = "width"
    }
}

