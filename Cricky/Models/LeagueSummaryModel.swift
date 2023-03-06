//
//  LeagueSummaryModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 24/2/23.
//

import Foundation

struct TeamStands {
    let teamName: String
    let teamID: Int
    let played, won, lost, draw, nR, point, position: Int
}

struct MostRunPlayerInfo {
    let mostRunPlayerID: Int
    let mostRunPlayerName: String
    let mostRunPlayerImage: String
    let mostRunPlayerRun: Int
    let mostRunPlayerMatchCount: Int
    let mostRunPlayedTeam: String
    let mostRunPlayerTeamID: Int
//    let mostRunPlayerTeamImage : String
}

struct LeagueStatistics {
    let leagueName, leagueImage: String

    let mostRun: Int
    let mostRunPlayedID: Int
    let mostRunPlayerName: String
    let mostRunPlayerImage: String
    let mostRunPlayerTeam: String

    let highestRun: Int
    let highestRunPlayedID: Int
    let highestRunPlayerName: String
    let highestRunPlayerImage: String
    let highestRunBall: Int
    let highestRunPlayerTeamName: String
    let highestRunPlayerTeamID: Int

    let mostWicket: Int
    let mostWicketPlayerName: String
    let mostWicketPlayerID: Int
    let mostWicketPlayerImage: String
    let mostWicketPlayerTeam: String
    let mostWicketPlayerTeamID: Int
    let mostWicketPlayerTeamImage: String

    let bestBowlingWicket: Int
    let bestBowlingRun: Int
    let bestBowlingPlayerName: String
    let bestBowlingPlayerID: Int
    let bestBowlingPlayerImage: String
    let bestBowlingTeam: String
    let bestBowlingTeamID: Int
    let bestBowlingWicketRate: Double
    let bestBowlingWicketOver: Double
    let totalMatches: Int
    // let best
}
