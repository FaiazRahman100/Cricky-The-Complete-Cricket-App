//
//  RankingModel.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import Foundation

struct RankRow {
    let gameType, teamName, rank, matches, points, rating: String
    let teamID: Int
    let teamImage: String
}

struct TeamRanks: Codable {
    let data: [MatchType]
}

// MARK: - Datum

struct MatchType: Codable {
//    let resource,
    let type: String?
//    let position, points, rating: NSNull?
    let gender: String?
    let team: [TeamName]?
}

// MARK: - Team

struct TeamName: Codable {
//    let resource: Resource?
    let id: Int?
    let name, code: String?
    let image_path: String?
    let country_id: Int?
    let national_team: Bool?
    let position: Int?

//    let updatedAt: String?
    let ranking: RankingClass?
}

// MARK: - RankingClass

struct RankingClass: Codable {
    let position, matches, points, rating: Int?
}
