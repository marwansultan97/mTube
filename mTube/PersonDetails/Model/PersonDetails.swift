//
//  PersonDetails.swift
//  mTube
//
//  Created by Marwan Osama on 2/22/21.
//

import Foundation

// MARK: - PersonDetails
struct PersonDetails: Codable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbID: String?
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String
    let popularity: Double
    let profilePath: String

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case alsoKnownAs = "also_known_as"
        case biography = "biography"
        case birthday = "birthday"
        case deathday = "deathday"
        case gender = "gender"
        case homepage = "homepage"
        case id = "id"
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case placeOfBirth = "place_of_birth"
        case popularity = "popularity"
        case profilePath = "profile_path"
    }
}
