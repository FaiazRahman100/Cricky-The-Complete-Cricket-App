//
//  MatchDetailsModel.swift
//  Cricky
//
//  Created by bjit on 20/2/23.
//

import Foundation

struct SelectedFixture: Codable {
    let data: Datum
}

struct MatchAllDetails {
    let team1Name, team1Code, team2Name, team2Code, team1Score, team2Score, team1Over, team2Over, result, momName, seriesName, round, date, umpire1, umpire2, toss, venue, venueCity: String

    let team1ID, team2ID, momID: Int
    let team1Img, team2Img, venueImg, momImage: String
}
