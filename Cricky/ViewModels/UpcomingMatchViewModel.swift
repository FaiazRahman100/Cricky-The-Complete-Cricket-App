//
//  UpcomingMatchViewModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import Foundation
import UIKit

class UpcomingMatchModel {
    var upcomingMatchAtoZ: ObservableObject<UpcomingMatchAllData?> = ObservableObject(nil)
    var loadingComplete: ObservableObject<Bool?> = ObservableObject(nil)
    var team1Stats: TeamStat?
    var team2Stats: TeamStat?

    var head2head: Head2H?

    var venueDetails: VenueHistory?
    var upcomingMatchEverything: UpcomingMatchAllData?
    var counter = 0
    var passedGame: MatchTiles? {
        didSet {
            getTeamStatistics(teamID: (passedGame?.localteam_id)!)
        }
    }

    func getTeamStatistics(teamID: Int) {
        var teamResults: TeamInfo?

        let apiToken = Constant.Key
        let baseUrl = Constant.baseUrl
        let teamId = teamID
        let include = "results"

        let link = APIQueryBuilder(baseUrl: baseUrl)
            .setEndpoint("/teams/\(teamID)")
            .addQueryParam(key: "api_token", value: apiToken)
            .addIncludeParam(include)
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { (result: Result<TeamHistory, Error>) in
            switch result {
            case let .success(response):
                teamResults = response.data
                process()

                debugPrint("We got a successful result with Team Data.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }

        func process() {
            // getHead2Head(data: teamResults)

            var lastMatches: [String] = []
            var win = 0
            var lose = 0
            var draw = 0

            var h2hCount = 0
            var h2hWinA = 0
            var h2hWinB = 0
            var h2hDraw = 0

            for i in 0 ..< teamResults!.results!.count {
                if teamResults?.results![i].visitorteam_id == passedGame?.visitorteam_id || teamResults?.results![i].localteam_id == passedGame?.visitorteam_id {
                    if let value = teamResults?.results![i].winner_team_id {
                        if value == passedGame?.localteam_id {
                            h2hWinA += 1
                        } else {
                            h2hWinB += 1
                        }
                    } else {
                        h2hDraw += 1
                    }

                    h2hCount += 1
                }

                if i < 10 {
                    if teamResults?.results![i].status == "Aban." {
                        lastMatches.append("D")
                        draw += 1
                    } else {
                        if teamResults?.results![i].winner_team_id == teamID {
                            lastMatches.append("W")
                            win += 1
                        } else {
                            lastMatches.append("L")
                            lose += 1
                        }
                    }
                }
            }

            if teamID == passedGame?.localteam_id {
                team1Stats = TeamStat(teamID: teamID, teamName: (teamResults?.name)!, last10Match: lastMatches, win: win, loss: lose, draw: draw, home: true)

                head2head = Head2H(teamAName: (passedGame?.localTeamName)!, teamAID: (passedGame?.localteam_id)!, teamBName: (passedGame?.visitorTeamName)!, teamBID: (passedGame?.visitorteam_id)!, totalGame: h2hCount, teamAWin: h2hWinA, teamBWin: h2hWinB, h2hDraw: h2hDraw)
            } else {
                team2Stats = TeamStat(teamID: teamID, teamName: (teamResults?.name)!, last10Match: lastMatches, win: win, loss: lose, draw: draw, home: false)
            }

            if counter == 0 {
                getTeamStatistics(teamID: (passedGame?.visitorteam_id)!)
                counter += 1
            } else {
                getVenueDetail(id: passedGame!.venue_id)
            }
        }
    }

    func getVenueDetail(id: Int) {
        var venueResults: VenueInfo?

        let apiToken = Constant.Key
        let baseUrl = Constant.baseUrl
        let iD = id
        let include = "fixtures"

        let link = APIQueryBuilder(baseUrl: baseUrl)
            .setEndpoint("/venues/\(iD)")
            .addQueryParam(key: "api_token", value: apiToken)
            .addIncludeParam(include)
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { (result: Result<VenueStructure, Error>) in
            switch result {
            case let .success(response):
                venueResults = response.data
                process()

                debugPrint("We got a successful result with Team Data.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }

        func process() {
            var batingFirstTeam = 0
            var battingFirstWin = 0
            var bowlingFirstWin = 0

            for i in 0 ..< (venueResults?.fixtures?.count)! {
                if venueResults?.fixtures![i].status != "Aban." && venueResults?.fixtures![i].status != "NS" {
                    if venueResults?.fixtures![i].elected == "batting" {
                        batingFirstTeam = (venueResults?.fixtures![i].toss_won_team_id)!
                    } else {
                        batingFirstTeam = tossLostTeam()

                        func tossLostTeam() -> Int {
                            var tossLostID = 0
                            let tossWinTeam = venueResults?.fixtures![i].toss_won_team_id

                            if tossWinTeam == venueResults?.fixtures![i].localteam_id {
                                tossLostID = (venueResults?.fixtures![i].visitorteam_id)!
                            } else {
                                tossLostID = (venueResults?.fixtures![i].localteam_id)!
                            }

                            return tossLostID
                        }
                    }

                    if venueResults?.fixtures![i].winner_team_id == batingFirstTeam {
                        battingFirstWin += 1
                    } else {
                        bowlingFirstWin += 1
                    }
                }
            }

            venueDetails = VenueHistory(venueName: (venueResults?.name)!, venueCity: (venueResults?.city)!, venueID: (venueResults?.id)!, venueImage: (venueResults?.image_path)!, totalMatches: (venueResults?.fixtures?.count)!, battingFirstWin: battingFirstWin, bowlingFirstWin: bowlingFirstWin, venueCapacity: (venueResults?.capacity)!)

            // update ui
            upcomingMatchEverything = UpcomingMatchAllData(team1Name: passedGame!.localTeamName, team2Name: passedGame!.visitorTeamName, team1Id: passedGame!.localteam_id, team2Id: passedGame!.visitorteam_id, team1Stat: team1Stats!, team2Stat: team2Stats!, venueStat: venueDetails!, head2head: head2head!, stageName: passedGame!.stage, round: passedGame!.round, date: passedGame!.date, time: passedGame!.time, team1Code: passedGame!.localTeamCode, team2Code: passedGame!.visitorTeamCode, team1Img: passedGame!.localTeamImg, team2Img: passedGame!.visitorTeamImg)

            upcomingMatchAtoZ.value = upcomingMatchEverything
            loadingComplete.value = true
        }
    }
}
