//
//  ShowImages.swift
//  mTube
//
//  Created by Marwan Osama on 2/17/21.
//

import Foundation


// MARK: - Images
struct ShowImages: Codable {
    let id: Int
    let backdrops: [Backdrop]
    let posters: [Backdrop]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case backdrops = "backdrops"
        case posters = "posters"
    }
}

// MARK: - Backdrop
struct Backdrop: Codable {
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let iso639_1: String?
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
