//
//  LeagueStandingModel.swift
//  Cricky
//
//  Created by bjit on 23/2/23.
//

import Foundation

// MARK: - LeagueStands

struct LeagueStands: Codable {
    let data: [TeamStand]
}

// MARK: - Datum

struct TeamStand: Codable {
    let team_id, stage_id, season_id, league_id: Int?
    let position, points, played, won: Int?
    let lost, draw, noresult, runsFor: Int?
    let oversFor: Double?
    let runsAgainst: Int?
    let oversAgainst, nettoRunRate: Double?
    let team: Team?
}
