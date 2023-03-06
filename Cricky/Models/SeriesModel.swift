//
//  SeriesModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 19/2/23.
//

import Foundation

struct SeriesInfo {
    let name: String
    let stageID: Int
    let leagueID: Int
    let seasonID: Int
}

struct StageStructure: Codable {
    let data: [Stages]
}

// MARK: - Datum

struct Stages: Codable {
    let id, league_id, season_id: Int?
    let name: String?
}
