//
//  UpcomingMatchModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import Foundation

struct TeamStat {
    let teamID: Int
    let teamName: String
    let last10Match: [String]
    let win: Int
    let loss: Int
    let draw: Int
    let home: Bool
}

struct Head2H {
    let teamAName: String
    let teamAID: Int
    let teamBName: String
    let teamBID: Int
    let totalGame: Int
    let teamAWin: Int
    let teamBWin: Int
    let h2hDraw: Int
}

struct VenueHistory {
    let venueName: String
    let venueCity: String
    let venueID: Int
    let venueImage: String
    let totalMatches: Int
    let battingFirstWin, bowlingFirstWin: Int
    let venueCapacity: Int
}

struct VenueStructure: Codable {
    let data: VenueInfo
}

// MARK: - DataClass

struct VenueInfo: Codable {
    let id, country_id: Int?
    let name, city: String?
    let image_path: String?
    let capacity: Int?
    let fixtures: [FixtureVenue]?
    let updatedAt: String?
}

// MARK: - Fixture

struct FixtureVenue: Codable {
    let round: String?
    let localteam_id, visitorteam_id: Int?
    let starting_at, type: String?
    let live: Bool?
    let status: String?
    let note: String?
    let venue_id: Int?
    let toss_won_team_id, winner_team_id: Int?
    let elected: String?
}

struct TeamList: Codable {
    let data: [TeamsData]
}

struct CertainTeam: Codable {
    let data: TeamsData
}

// MARK: - Datum

struct TeamsData: Codable {
    let id: Int
    let name, code: String
    let image_path: String
    let country_id: Int
    let national_team: Bool
}

struct UpcomingMatchAllData {
    let team1Name, team2Name: String
    let team1Id, team2Id: Int
    let team1Stat: TeamStat
    let team2Stat: TeamStat
    let venueStat: VenueHistory
    let head2head: Head2H

    let stageName: String
    let round: String
    let date: String
    let time: String
    let team1Code, team2Code: String
    let team1Img, team2Img: String

    // let winningPercentage
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ranking = try? JSONDecoder().decode(Ranking.self, from: jsonData)

// MARK: - Ranking

struct TeamHistory: Codable {
    let data: TeamInfo
}

// MARK: - DataClass

struct TeamInfo: Codable {
    let id: Int?
    let name, code: String?
    let image_path: String?
    let country_id: Int?
    let national_team: Bool?
    let results: [TeamResult]?
}

// MARK: - Result

struct TeamResult: Codable {
    let id, league_id, season_id, stage_id: Int?
    let round: String?
    let localteam_id, visitorteam_id: Int?
    let starting_at: String?
    let type: String?
    let live: Bool?
    let status: String
    let note: String?
    let venue_id, toss_won_team_id: Int?
    let winner_team_id: Int?
    let draw_noresult: String?
    let first_umpire_id, second_umpire_id, tv_umpire_id, referee_id: Int?
    let man_of_match_id, man_of_series_id, total_overs_played: Int?
    let elected: String?
    let super_over, follow_on: Bool?
}
