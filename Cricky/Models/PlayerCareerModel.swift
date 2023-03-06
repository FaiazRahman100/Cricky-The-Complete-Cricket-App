//
//  PlayerCareerModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import Foundation

struct PlayerIdentity {
    let id: Int
    let name: String
    let image: String
    let position: String
}

struct TeamX {
    let teamName: String
    let playerList: [PlayerIdentity]
}

struct rowWiseRecord {
    let name, t20, t20I, odi: String
}

// MARK: - Player

struct Player: Codable {
    let data: PlayerData?
}

// MARK: - DataClass

struct PlayerData: Codable {
//    let resource: String?
    let id: Int?
    let fullname: String?
    let image_path: String?
    let dateofbirth, gender, battingstyle, bowlingstyle: String?
    let position: Positionx?
    let country: Country?
    let updated_at: String?
    let career: [Career]?
    let teams, currentteams: [Team]?
}

// MARK: - Career

struct Career: Codable {
    let type: String?
    let season_id, player_id: Int?
    let bowling: [String: Double?]?

    // here when all data of batting = int problem arrise
    let batting: [String: Double?]?
    let updated_at: String?
    let season: Season?
}

// MARK: - Season

struct Season: Codable {
    let resource: String?
    let id, leagueID: Int?
    let name, code, updatedAt: String?
}

// MARK: - Country

struct Country: Codable {
    // let resource: String?
    // let id, continentID: Int?
    let name: String?
    let image_path: String?
    // let updatedAt: NSNull?
}

// MARK: - Team

struct Team: Codable {
    // let resource: String?
    let id: Int?
    let name, code: String?
    let image_path: String?
    let country_id: Int?
    let national_team: Bool?
    let updatedAt: String?
    // let inSquad: InSquad?
}

// MARK: - InSquad

struct InSquad: Codable {
    let seasonID, leagueID: Int?
}

// MARK: - Position

struct Positionx: Codable {
    //   let resource: String?
    //   let id: Int?
    let name: String?
}
