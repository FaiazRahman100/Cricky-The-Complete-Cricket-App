//
//  PlayerListModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 23/2/23.
//

import Foundation

// MARK: - PlayerAll

struct PlayerAll: Codable {
    let data: [PlayerDetail]
}

// MARK: - Datum

struct PlayerDetail: Codable {
    let id: Int?
    let fullname: String?
    let image_path: String?
    let country: Country2
}

// MARK: - Country

struct Country2: Codable {
    let id: Int?
    let name: String?
    let image_path: String?
}

struct PlayerMiniInfo {
    let id: Int
    let name: String
    let playerImg: String
    let country: String
    let countryImg: String
}

struct playerAllInfo {
    let name: String
    let image: String
    let position: String
    let dob: String
    let battingStyle: String
    let bowlingStyle: String
    let playingTeams: [playingTeam]
    let playerCountry, playerCountryImage: String
}

struct playingTeam {
    let id: Int
    let name: String
    let image: String
}
