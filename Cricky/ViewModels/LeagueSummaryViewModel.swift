//
//  LeagueSummaryViewModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 24/2/23.
//

import Foundation

class LeagueSummaryViewModel {
    var allSummary: ObservableObject<LeagueStatistics?> = ObservableObject(nil)
    var loadingComplete: ObservableObject<Bool?> = ObservableObject(nil)

    func getMatchData(season: Int) {
        var fixtureList: [Datum] = []

        let builder = APIQueryBuilder(baseUrl: Constant.baseUrl)
        let link = builder
            .setEndpoint("/fixtures")
            .addQueryParam(key: "api_token", value: Constant.Key)
            .addQueryParam(key: "sort", value: "-starting_at")
            .addQueryParam(key: "filter[season_id]", value: "\(season)")
            .addIncludeParam("stage")
            .addIncludeParam("localteam")
            .addIncludeParam("visitorteam")
            .addIncludeParam("tosswon")
            .addIncludeParam("winnerteam")
            .addIncludeParam("venue")
            .addIncludeParam("manofmatch")
            .addIncludeParam("lineup")
            .addIncludeParam("scoreboards.team")
            .addIncludeParam("runs.team")
            .addIncludeParam("batting.batsman")
            .addIncludeParam("batting.result")
            .addIncludeParam("batting.bowler")
            .addIncludeParam("batting.catchstump")
            .addIncludeParam("batting.batsmanout")
            .addIncludeParam("batting.runoutby")
            .addIncludeParam("bowling.bowler")
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { (result: Result<Fixture, Error>) in
            switch result {
            case let .success(response):
                fixtureList = response.data
                process()
                debugPrint("We got a successful result with \(response.data.count) League matches.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }

        func process() {
            var highestRun = 0
            var highestRunPlayedID = 0
            var highestRunPlayerName = ""
            var highestRunBall = 0
            var highestRunPlayerTeamName = ""
            var highestRunPlayerTeamID = 0
            var highestRunPlayerImage = ""

            //
            var bestBowlingWicket = 0
            var bestBowlingRun = 0
            var bestBowlingPlayerName = ""
            var bestBowlingPlayerID = 0
            var bestBowlingPlayerImage = ""
            var bestBowlingTeam = ""
            var bestBowlingTeamID = 0
            var bestBowlingWicketRate = 100.0
            var bestBowlingWicketOver = 0.0

            var mostRunDict: [Int: MostRunPlayerInfo] = [:]
            var mostWicketDic: [String: Int] = [:]

            // playerScoreDic: [Int : Struct]

            // function to generate
            for i in 0 ..< fixtureList.count {
                let localTeamId = (fixtureList[i].localteam?.id)!
                let localTeamName = (fixtureList[i].localteam?.name)!

                let visitorTeamId = (fixtureList[i].visitorteam?.id)!
                let visitorTeamName = (fixtureList[i].visitorteam?.name)!

                let teamDic = [localTeamId: localTeamName, visitorTeamId: visitorTeamName]

                for battingIndex in 0 ..< fixtureList[i].batting!.count {
                    let currentRun = fixtureList[i].batting![battingIndex].score
                    if currentRun! > highestRun {
                        highestRun = currentRun!
                        highestRunPlayedID = (fixtureList[i].batting![battingIndex].batsman?.id)!
                        highestRunPlayerName = (fixtureList[i].batting![battingIndex].batsman?.fullname)!
                        highestRunBall = (fixtureList[i].batting![battingIndex].ball)!
                        highestRunPlayerTeamID = (fixtureList[i].batting![battingIndex].team_id)!
                        highestRunPlayerImage = (fixtureList[i].batting![battingIndex].batsman?.image_path)!
                        highestRunPlayerTeamName = teamDic[highestRunPlayerTeamID] ?? "Unknown"
                    }

                    let playerID = fixtureList[i].batting![battingIndex].batsman?.id
                    let playerName = fixtureList[i].batting![battingIndex].batsman?.fullname
                    let playerImage = fixtureList[i].batting![battingIndex].batsman?.image_path
                    let playerRuns = fixtureList[i].batting![battingIndex].score
                    let playerTeamID = (fixtureList[i].batting![battingIndex].team_id)!
                    let playerTeamName = teamDic[playerTeamID] ?? "Unknown"
                    let matchCount = 1
                    // let mostRunPlayerTeamImage = (fixtureList[i].batting![battingIndex].i)!

                    let tempMostRun = MostRunPlayerInfo(mostRunPlayerID: playerID!, mostRunPlayerName: playerName!, mostRunPlayerImage: playerImage!, mostRunPlayerRun: playerRuns!, mostRunPlayerMatchCount: matchCount, mostRunPlayedTeam: playerTeamName, mostRunPlayerTeamID: playerTeamID)

                    if let currentPlayer = mostRunDict[playerID!] {
                        // this loop executes if this player already saved in dictionary

                        //  print("previous run \(currentPlayer.mostRunPlayerRun)")
                        let newTotalRun = currentPlayer.mostRunPlayerRun + playerRuns!
                        //   print("new Run \(newTotalRun)")
                        let newMatchCount = currentPlayer.mostRunPlayerMatchCount + 1

                        let temp2 = MostRunPlayerInfo(mostRunPlayerID: playerID!, mostRunPlayerName: playerName!, mostRunPlayerImage: playerImage!, mostRunPlayerRun: newTotalRun, mostRunPlayerMatchCount: newMatchCount, mostRunPlayedTeam: playerTeamName, mostRunPlayerTeamID: playerTeamID)
//                        let updatedScore = currentScore + playerScore!
                        mostRunDict[playerID!] = temp2

                    } else {
                        // otherwise save the player detail with new dictionary entry
                        mostRunDict[playerID!] = tempMostRun
                    }
                }

                //////

                for bowlingIndex in 0 ..< fixtureList[i].bowling!.count {
                    let currentWicket = fixtureList[i].bowling![bowlingIndex].wickets
                    let currentRate = fixtureList[i].bowling![bowlingIndex].rate

                    if currentWicket! >= bestBowlingWicket && currentRate! <= bestBowlingWicketRate {
                        bestBowlingWicket = currentWicket!
                        bestBowlingWicketRate = currentRate!
                        bestBowlingRun = fixtureList[i].bowling![bowlingIndex].runs!
                        bestBowlingWicketOver = fixtureList[i].bowling![bowlingIndex].overs!
                        bestBowlingWicketRate = fixtureList[i].bowling![bowlingIndex].rate!

                        bestBowlingPlayerName = (fixtureList[i].bowling![bowlingIndex].bowler?.fullname)!
                        bestBowlingPlayerID = (fixtureList[i].bowling![bowlingIndex].bowler?.id)!
                        bestBowlingPlayerImage = (fixtureList[i].bowling![bowlingIndex].bowler?.image_path)!
                        bestBowlingTeamID = (fixtureList[i].bowling![bowlingIndex].team_id)!
                        bestBowlingTeam = teamDic[bestBowlingTeamID] ?? "Unknown"
                    }

                    let mostWicket = (fixtureList[i].bowling![bowlingIndex].wickets)!
                    // print(mostWicket)
                    let mostWicketBowlerName = (fixtureList[i].bowling![bowlingIndex].bowler?.fullname)!
                    let mostWicketBowlerID = (fixtureList[i].bowling![bowlingIndex].bowler?.id)!
                    let mostWicketBowlerImage = (fixtureList[i].bowling![bowlingIndex].bowler?.image_path)!
                    let mostWicketBowlerTeamID = (fixtureList[i].bowling![bowlingIndex].team_id)!
                    let mostWicketBowlerTeam = teamDic[mostWicketBowlerTeamID] ?? "Unknown"

                    let mostWicketDetail = "PlayerName: \(mostWicketBowlerName), PlayerID: \(mostWicketBowlerID), PlayerImage: \(mostWicketBowlerImage), PlayerTeam: \(mostWicketBowlerTeam)"

                    if let currentWicket = mostWicketDic[mostWicketDetail] {
                        let updatedWicket = currentWicket + mostWicket
                        // print(updatedWicket)
                        mostWicketDic[mostWicketDetail] = updatedWicket

                    } else {
                        mostWicketDic[mostWicketDetail] = mostWicket
                        // dump(mostWicketDic[mostWicketDetail])
                    }
                }
            }

            let mostWicket = mostWicketDic.values.max()
            var mostWicketPlayerDetail = ""
            if let key = mostWicketDic.first(where: { $0.value == mostWicket })?.key {
                mostWicketPlayerDetail = key
            }

            var mostWicketPlayerId = 0
            var mostWicketPlayerName = ""
            var mostWicketPlayerImage = ""
            var mostWicketPlayerTeam = ""
            (mostWicketPlayerId, mostWicketPlayerName, mostWicketPlayerImage, mostWicketPlayerTeam) = getMostWicketDetail(mostWicketPlayerDetail) ?? (4, "", "", "")
            print(mostWicketPlayerName)

            var higestScore = 0
            var mostRunPlayerProfile: MostRunPlayerInfo?

            for (_, value) in mostRunDict {
                let currentPlayerScore = value.mostRunPlayerRun
                if currentPlayerScore > higestScore {
                    higestScore = currentPlayerScore
                    mostRunPlayerProfile = value
                }
            }

            var leagueName = ""
            var leagueImage = ""
            let leagueList = PreSavedDataSt.shared.leagueList
            for i in 0 ..< leagueList.count {
                if leagueList[i].seasonID == season {
                    leagueName = leagueList[i].leagueName
                    leagueImage = leagueList[i].leagueImage
                }
            }

            let totalMatches = fixtureList.count
            let temp = LeagueStatistics(leagueName: leagueName, leagueImage: leagueImage, mostRun: mostRunPlayerProfile!.mostRunPlayerRun, mostRunPlayedID: mostRunPlayerProfile!.mostRunPlayerID, mostRunPlayerName: mostRunPlayerProfile!.mostRunPlayerName, mostRunPlayerImage: mostRunPlayerProfile!.mostRunPlayerImage, mostRunPlayerTeam: mostRunPlayerProfile!.mostRunPlayedTeam, highestRun: highestRun, highestRunPlayedID: highestRunPlayedID, highestRunPlayerName: highestRunPlayerName, highestRunPlayerImage: highestRunPlayerImage, highestRunBall: highestRunBall, highestRunPlayerTeamName: highestRunPlayerTeamName, highestRunPlayerTeamID: highestRunPlayerTeamID, mostWicket: mostWicket!, mostWicketPlayerName: mostWicketPlayerName, mostWicketPlayerID: mostWicketPlayerId, mostWicketPlayerImage: mostWicketPlayerImage, mostWicketPlayerTeam: mostWicketPlayerTeam, mostWicketPlayerTeamID: 0, mostWicketPlayerTeamImage: "", bestBowlingWicket: bestBowlingWicket, bestBowlingRun: bestBowlingRun, bestBowlingPlayerName: bestBowlingPlayerName, bestBowlingPlayerID: bestBowlingPlayerID, bestBowlingPlayerImage: bestBowlingPlayerImage, bestBowlingTeam: bestBowlingTeam, bestBowlingTeamID: bestBowlingTeamID, bestBowlingWicketRate: bestBowlingWicketRate, bestBowlingWicketOver: bestBowlingWicketOver, totalMatches: totalMatches)
            loadingComplete.value = true
            allSummary.value = temp
        }
    }

    func getMostWicketDetail(_ inputString: String) -> (Int, String, String, String)? {
        let regex = try! NSRegularExpression(pattern: "PlayerName: (.*), PlayerID: (\\d+), PlayerImage: (.*), PlayerTeam: (.*)")

        if let match = regex.firstMatch(in: inputString, range: NSRange(inputString.startIndex..., in: inputString)) {
            let playerName = String(inputString[Range(match.range(at: 1), in: inputString)!])
            let playerID = Int(inputString[Range(match.range(at: 2), in: inputString)!])!
            let playerImage = String(inputString[Range(match.range(at: 3), in: inputString)!])
            let playerTeam = String(inputString[Range(match.range(at: 4), in: inputString)!])
            return (playerID, playerName, playerImage, playerTeam)
        } else {
            return nil
        }
    }
}
