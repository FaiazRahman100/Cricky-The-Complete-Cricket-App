//
//  MatchesViewModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import Foundation
import UIKit

class MatchesViewModel {
    var defaults = UserDefaults.standard
    var fixtureList: ObservableObject<[MatchTiles]?> = ObservableObject(nil)

    var tableData: ObservableObject<[MatchTiles]?> = ObservableObject(nil)
    var loadingComplete: ObservableObject<Bool?> = ObservableObject(nil)

    var matchList: [MatchTiles] = []

    func allMatchesSelected() {
        tableData.value = matchList
    }

    func recentMatchedSelected() {
        var recentMatches: [MatchTiles] = []
        for i in 0 ..< matchList.count {
            if matchList[i].status == "Finished" {
                recentMatches.append(matchList[i])
            }
        }
        tableData.value = recentMatches
    }

    func upcomingMatchSelected() {
        var upcomingMatches: [MatchTiles] = []
        for i in 0 ..< matchList.count {
            if matchList[i].status == "NS" {
                upcomingMatches.append(matchList[i])
            }
        }
        let alreadySchedule = defaults.integer(forKey: "scheduled")

        if alreadySchedule == 0 {
            for i in 0 ..< upcomingMatches.count {
                let matchtime = upcomingMatches[i].date
                let team1 = upcomingMatches[i].team1Name
                let team2 = upcomingMatches[i].team2Name

                NotificationManager.shared.scheduleNotification(for: matchtime, team1: team1, team2: team2)
            }
            defaults.set(1, forKey: "scheduled")
        }
        tableData.value = upcomingMatches.reversed()
    }

    func liveMatchSelected() {
        var liveMatch: [MatchTiles] = []
        for i in 0 ..< matchList.count {
            if matchList[i].status != "NS" && matchList[i].status != "Finished" && matchList[i].status != "Aban." {
                liveMatch.append(matchList[i])
            }
        }
        tableData.value = liveMatch
    }

    func downloadFixture(link: String) {
        var receiveData: [Datum]?

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [weak self] (result: Result<Fixture, Error>) in
            switch result {
            case let .success(response):
                receiveData = response.data
                self?.loadingComplete.value = true
                process()
                self?.tableData.value = self?.matchList

                debugPrint("We got a successful result with \(response.data.count) Matches.")
            case let .failure(error):
                self?.loadingComplete.value = false
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }

        func process() {
            for i in 0 ..< receiveData!.count {
                let fixId = receiveData![i].id
                let date = receiveData![i].starting_at
                let timeX = getConvertedTime(receiveData![i].starting_at!)
                let status = receiveData![i].status

                var team1Score = ""
                var team1Over = ""
                var team1Code = (receiveData![i].localteam?.code)!

                var team2Score = ""
                var team2Over = ""
                var team2Code = (receiveData![i].visitorteam?.code)!

                var team1Image = (receiveData![i].localteam?.image_path)!
                var team2Image = (receiveData![i].visitorteam?.image_path)!

                var team1ID = receiveData![i].localteam_id
                var team2ID = receiveData![i].visitorteam_id

                if receiveData![i].status != "NS" {
                    if receiveData![i].runs?.count == 2 {
                        team1Score = String(receiveData![i].runs?[0].score ?? 0) + "-" + String(receiveData![i].runs?[0].wickets ?? 0)
                        team1Over = String(receiveData![i].runs?[0].overs ?? 0)
                        team1Over = "(\(team1Over))"
                        team1Code = (receiveData![i].runs?[0].team?.code)!
                        team1Image = (receiveData![i].runs?[0].team?.image_path)!
                        team1ID = (receiveData![i].runs?[0].team?.id)!

                        team2ID = (receiveData![i].runs?[1].team?.id)!
                        team2Score = String(receiveData![i].runs?[1].score ?? 0) + "-" + String(receiveData![i].runs?[1].wickets ?? 0)
                        team2Over = String(receiveData![i].runs?[1].overs ?? 0)
                        team2Over = "(\(team2Over))"
                        team2Code = (receiveData![i].runs?[1].team?.code)!
                        team2Image = (receiveData![i].runs?[1].team?.image_path)!

                    } else if receiveData![i].runs?.count == 1 {
                        team1Code = (receiveData![i].runs?[0].team?.code)!
                        team1Score = String(receiveData![i].runs?[0].score ?? 0) + "-" + String(receiveData![i].runs?[0].wickets ?? 0)
                        team1Over = String(receiveData![i].runs?[0].overs ?? 0)
                        team1Over = "(\(team1Over))"
                        team1Image = (receiveData![i].runs?[0].team?.image_path)!
                        team1ID = (receiveData![i].runs?[0].team?.id)!
                        team2Score = "0-0"
                        team2Over = "(0.0)"
                        if team1Code != (receiveData![i].localteam?.code)! {
                            team2Code = (receiveData![i].localteam?.code)!
                            team2Image = (receiveData![i].localteam?.image_path)!
                            team2ID = (receiveData![i].localteam_id)!
                        } else {
                            team2Code = (receiveData![i].visitorteam?.code)!
                            team2Image = (receiveData![i].visitorteam?.image_path)!
                            team2ID = (receiveData![i].visitorteam_id)!
                        }
                    }
                }

                let noteZ = receiveData![i].note
                let stage = receiveData![i].stage?.name
                let round = receiveData![i].round ?? ""

                let venue = receiveData![i].venue?.name ?? ""
                let venueCity = receiveData![i].venue?.city ?? ""

                let temp = MatchTiles(fixtureID: fixId!, date: date!, time: timeX, status: status!, team1Name: team1Code, team2Name: team2Code, team1Score: team1Score, team2Score: team2Score, team1Over: team1Over, team2Over: team2Over, team1Img: team1Image, team2Img: team2Image, stage: stage!, note: noteZ!, round: round, venue: venue, venueCity: venueCity, team1ID: team1ID!, team2ID: team2ID!, localteam_id: receiveData![i].localteam_id!, visitorteam_id: receiveData![i].visitorteam_id!, localTeamName: receiveData![i].localteam!.name!, visitorTeamName: receiveData![i].visitorteam!.name!, venue_id: receiveData![i].venue_id ?? 23, localTeamCode: receiveData![i].localteam!.code!, visitorTeamCode: receiveData![i].visitorteam!.code!, localTeamImg: receiveData![i].localteam!.image_path!, visitorTeamImg: receiveData![i].visitorteam!.image_path!)

                matchList.append(temp)
                // fixtureList.value.append(temp)
            }
        }
    }
}
