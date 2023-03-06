//
//  ScoreboardModel.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import Foundation

struct BattingData {
    let playerID: Int
    let playerName, score, four, six, srikeRate, outStatus, ball: String
}

struct BowlingData {
    let playerID: Int
    let playerName, overs, medians, run, wicket, ecRate: String
}
