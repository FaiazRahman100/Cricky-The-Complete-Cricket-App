//
//  MatchesModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import Foundation

struct MatchTiles {
    let fixtureID: Int
    let date, time, status, team1Name, team2Name, team1Score, team2Score, team1Over, team2Over, team1Img, team2Img, stage, note, round, venue, venueCity: String
    let team1ID, team2ID: Int
    let localteam_id, visitorteam_id: Int
    let localTeamName, visitorTeamName: String
    let venue_id: Int
    let localTeamCode, visitorTeamCode: String
    let localTeamImg, visitorTeamImg: String
}

// MARK: - Fixture

struct Fixture: Codable {
    let data: [Datum]
}

// MARK: - Datum

struct Datum: Codable {
    // let resource: DatumResource
    let id, league_id, season_id, stage_id: Int?
    let round: String?
    let localteam_id, visitorteam_id: Int?
    let starting_at: String?
    let type: String?
    let live: Bool?
    let status: String?
    let note: String?
    let venue_id, toss_won_team_id: Int?
    let winner_team_id: Int?
    let drawNoresult: String?
    let first_umpire_id, second_umpire_id: Int?
    let man_of_match_id, man_of_series_id, total_overs_played: Int?
    let elected: String?
    let super_over, follow_on: Bool?
    let localteam, visitorteam, tosswon: Localteam?
    let batting: [Batting]?
    let bowling: [Bowling]?
    let runs: [Run]?
    let scoreboards: [ScoreboardElement]?
    let lineup: [Manofmatch]?

    let manofmatch: Manofmatch?
    let firstumpire, secondumpire: Umpire?
    let winnerteam: Localteam?
    let venue: Venue?
    let stage: Stage?
}

// MARK: - Venue

struct Venue: Codable {
    // let resource: VenueResource?
    // let id, countryID: Int?
    let name, city: String?
    let image_path: String?
    let capacity: Int?
    // let floodlight: Bool?
    // let updatedAt: String?
}

// MARK: - Stage

struct Stage: Codable {
    // let resource: StageResource?
    //  let id, leagueID, seasonID: Int?
    let name: String?
    //  let code: StageCode?
    let type: String?
    //  let standings: Bool?
    //  let updatedAt: StageUpdatedAt?
}

// MARK: - Umpire

struct Umpire: Codable {
    // let resource: FirstumpireResource?
    //  let id, countryID: Int?
    let firstname, lastname, fullname, dateofbirth: String?
    // let gender: Gender?
    // let updatedAt: String?
}

// MARK: - ScoreboardElement

struct ScoreboardElement: Codable {
    //   let resource: ScoreboardResource?
    let id, fixture_id, team_id: Int?
    let type: String?
    let scoreboard: String?
    let wide, noball_runs, noball_balls, bye: Int?
    let leg_bye, penalty, total: Int?
    let overs: Double?
    let wickets: Int?
    let updatedAt: String?
    let team: Localteam?
}

// MARK: - Run

struct Run: Codable {
    //  let resource: RunResource?
    let id, fixture_id, team_id, inning: Int?
    let score, wickets: Int?
    let overs: Double?
    let pp1: String?
    let pp2: String?
    //  let pp3: NSNull?
    //  let updatedAt: String?
    let team: Localteam?
}

// MARK: - Bowling

struct Bowling: Codable {
    // let resource: BowlingResource?
    let id, sort, fixture_id, team_id: Int?
    let active: Bool?
    let scoreboard: String?
    let player_id: Int?
    let overs: Double?
    let medians, runs, wickets, wide: Int?
    let noball: Int?
    let rate: Double?
    //  let updatedAt: String?
    let bowler: Manofmatch?
}

//// MARK: - Batting
struct Batting: Codable {
    // let resource: BattingResource?
    // let id, sort, fixtureID, teamID: Int?
    let team_id: Int?
    let sort: Int?
    let active: Bool?
    let scoreboard: String?
    let player_id, ball, score_id, score: Int?
    let four_x, six_x: Int?
    let catch_stump_player_id, runout_by_id: Int?
    let batsmanout_id: Int?
    let bowling_player_id: Int?
    let fow_score: Int?
    let fow_balls: Double?
    let rate: Double?
    let updated_at: String?

    let batsman: Manofmatch?
    let bowler, catchstump: Manofmatch?
    //  //  let batsmanout: NSNull?
    let runoutby: Manofmatch?
    let result: Results?
}

// MARK: - Result

struct Results: Codable {
    // let resource: ResultResource?
    // let id: Int?
    let name: String?
    let runs: Int?
    let four, six: Bool?
    let bye, leg_bye, noball, noball_runs: Int?
    let is_wicket, ball, out: Bool?
}

// MARK: - Manofmatch

struct Manofmatch: Codable {
//    let resource: ManofmatchResource?
    let id: Int?
    //   let firstname, lastname: String?
    let fullname, lastname, firstname: String?
    let image_path: String?
    let dateofbirth: String?
    //   let gender: Gender?
    let battingstyle: String?
    let bowlingstyle: String?
    let position: Position?
    // let updatedAt: String?
    // let lineup: Lineup?
}

// MARK: - Position

struct Position: Codable {
    //  let resource: PositionResource?
    let id: Int?
    let name: String?
}

// MARK: - Localteam

struct Localteam: Codable {
    // let resource: LocalteamResource
    let id: Int?
    let name, code: String?
    let image_path: String?
    let country_id: Int?
    let national_team: Bool?
}
