//
//  ScoreboardViewModel.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import Foundation
import UIKit

class ScoreboardViewModel {
    var selectedSeason: ObservableObject<sbSeason?> = ObservableObject(nil)

    var passedGame: Datum? {
        didSet {
            processData()
        }
    }

//    var scoreboardData = [sbSeason]()
    var s1: sbSeason?
    var s2: sbSeason?

    func s1Selected() {
        selectedSeason.value = s1
    }

    func s2selected() {
        selectedSeason.value = s2
    }

    func processData() {
        let localTeamId = passedGame?.localteam?.id
        let localTeamName = passedGame?.localteam?.name

        let visitorTeamId = passedGame?.visitorteam?.id
        let visitorTeamName = passedGame?.visitorteam?.name

        let teamDic = [localTeamId: localTeamName, visitorTeamId: visitorTeamName]

        var scoreS1 = ""
        var scoreS2 = ""

        var teamS1Name = "" // teamDic[passedGame!.batting![0].team_id]!!
        var teamS2Name = "" // teamS1Name == localTeamName ? visitorTeamName! : localTeamName!
//        print(teamS1)

        if passedGame?.runs?.count == 2 && passedGame!.batting!.count != 0{
            scoreS1 = String(passedGame!.runs?[0].score ?? 0) + "-" + String(passedGame!.runs?[0].wickets ?? 0) + " " + "(" + String(passedGame!.runs?[0].overs ?? 0) + ")"
            scoreS2 = String(passedGame!.runs?[1].score ?? 0) + "-" + String(passedGame!.runs?[1].wickets ?? 0) + " " + "(" + String(passedGame!.runs?[1].overs ?? 0) + ")"
//
            teamS1Name = teamDic[passedGame!.batting![0].team_id]!!
            teamS2Name = teamS1Name == localTeamName ? visitorTeamName! : localTeamName!
        } else if passedGame?.runs?.count == 1 && passedGame!.batting!.count != 0{
            scoreS1 = String(passedGame!.runs?[0].score ?? 0) + "-" + String(passedGame!.runs?[0].wickets ?? 0) + " " + "(" + String(passedGame!.runs?[0].overs ?? 0) + ")"
            scoreS2 = "0-0 (0.0)"
            teamS1Name = teamDic[passedGame!.batting![0].team_id]!!
            teamS2Name = teamS1Name == localTeamName ? visitorTeamName! : localTeamName!
        }

        let battingS1 = getBattingStat(season: "S1")
        let bowlingS1 = getBowlingStat(season: "S1")
        let battingS2 = getBattingStat(season: "S2")
        let bowlingS2 = getBowlingStat(season: "S2")
        s1 = sbSeason(battingStat: battingS1, bowlingStat: bowlingS1, seasonName: teamS1Name, seasonScore: scoreS1)
        s2 = sbSeason(battingStat: battingS2, bowlingStat: bowlingS2, seasonName: teamS2Name, seasonScore: scoreS2)

        selectedSeason.value = s1
    }

    func getBattingStat(season: String) -> [BattingData] {
        var data: [BattingData] = []
        let header = BattingData(playerID: 0, playerName: "Batsman", score: "R", four: "4s", six: "6s", srikeRate: "SR", outStatus: "", ball: "B")
        data.append(header)
        for i in 0 ..< (passedGame?.batting!.count)! {
            if passedGame?.batting![i].scoreboard == season {
                let playerName = passedGame?.batting![i].batsman?.fullname
                let playerID = passedGame?.batting![i].player_id
                let score = passedGame?.batting![i].score
                let four = passedGame?.batting![i].four_x
                let six = passedGame?.batting![i].six_x
                let strikeRate = passedGame?.batting![i].rate
                let outStatus = getOutDetails(i)
                let ball = passedGame?.batting![i].ball

                let temp = BattingData(playerID: playerID!, playerName: String(playerName!), score: String(score!), four: String(four!), six: String(six!), srikeRate: String(strikeRate!), outStatus: outStatus, ball: String(ball!))

                data.append(temp)
//                var temp = battingData()
//                temp.playerID = passedGame?.batting[i].player_id
            }
        }

        return data
    }

    func getBowlingStat(season: String) -> [BowlingData] {
        var data: [BowlingData] = []
        let header = BowlingData(playerID: 0, playerName: "Bowler", overs: "O", medians: "M", run: "R", wicket: "W", ecRate: "ER")
        data.append(header)
        for i in 0 ..< (passedGame?.bowling!.count)! {
            if passedGame?.bowling![i].scoreboard == season {
                let playerName = passedGame?.bowling![i].bowler?.fullname
                let playerID = passedGame?.bowling![i].player_id
                let overs = passedGame?.bowling![i].overs
                let medians = passedGame?.bowling![i].medians
                let run = passedGame?.bowling![i].runs
                let wickets = passedGame?.bowling![i].wickets
                let ecRate = passedGame?.bowling![i].rate

                let temp = BowlingData(playerID: playerID!, playerName: String(playerName!), overs: String(overs!), medians: String(medians!), run: String(run!), wicket: String(wickets!), ecRate: String(ecRate!))

                data.append(temp)
//                var temp = battingData()
//                temp.playerID = passedGame?.batting[i].player_id
            }
        }

        return data
    }

    func getOutDetails(_ i: Int) -> String {
        let outStatus = passedGame?.batting![i].result?.name
        var details = ""
//
        if outStatus == "Run Out" {
            let runOutby = passedGame?.batting![i].runoutby?.firstname ?? "Rahman"
            details = "Run Out by \(runOutby)"
        } else if outStatus == "Catch Out" {
            let catchBy = passedGame?.batting![i].catchstump?.firstname ?? "Rahman"
            let ballBy = passedGame?.batting![i].bowler?.firstname ?? "Rahman"
            details = "c \(catchBy) b \(ballBy)"

        } else if outStatus == "Catch Out (Sub)" {
            let catchBy = passedGame?.batting![i].catchstump?.firstname ?? "Rahman"
            let ballBy = passedGame?.batting![i].bowler?.firstname ?? "Rahman"
            details = "c(sub) \(catchBy) b \(ballBy)"

        } else if outStatus == "LBW OUT" {
            let ballBy = passedGame?.batting![i].bowler?.firstname ?? "Rahman"
            details = "LBW b \(ballBy)"

        } else if outStatus == "Stump Out" {
            let stumpBy = passedGame?.batting![i].catchstump?.firstname ?? "Rahman"
            let ballBy = passedGame?.batting![i].bowler?.firstname ?? "Rahman"
            details = "stmp \(stumpBy) b \(ballBy)"

        } else if outStatus == "Clean Bowled" {
            let ballBy = passedGame?.batting![i].bowler?.firstname ?? "Rahman"
            details = "Bowled b \(ballBy)"
        } else {
            details = "Not Out"
        }

//
//
        return details
    }
}
