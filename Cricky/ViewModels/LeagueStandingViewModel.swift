//
//  LeagueStandingViewModel.swift
//  Cricky
//
//  Created by bjit on 23/2/23.
//

import Foundation

class LeagueStandingViewModel {
    var tableArray: ObservableObject<[RankRow]?> = ObservableObject(nil)

    var loaderArray: [TeamStand] = []

    var leagueStanding: [RankRow] = []
    var loadingComplete: ObservableObject<Bool?> = ObservableObject(nil)

    func requestApi(seasonId: Int) {
        let apiToken = Constant.Key
        let baseUrl = Constant.baseUrl
        let seasonID = seasonId
        let include = "team"

        let link = APIQueryBuilder(baseUrl: baseUrl)
            .setEndpoint("/standings/season/\(seasonID)")
            .addQueryParam(key: "api_token", value: apiToken)
            .addIncludeParam(include)
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [self] (result: Result<LeagueStands, Error>) in
            switch result {
            case let .success(response):
                loaderArray = response.data

                processData()

                debugPrint("We got a successful result with \(response.data.count) users.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
    }

    func processData() {
        leagueStanding = getRanking()
        loadingComplete.value = true
        tableArray.value = leagueStanding
        // dump(t20iRanking)
    }

    func getRanking() -> [RankRow] {
        var data: [RankRow] = []

        let headerRow = RankRow(gameType: "League", teamName: "Team", rank: "Rank", matches: "M", points: "Points", rating: "W", teamID: 0, teamImage: "")
        data.append(headerRow)

        for i in 0 ..< loaderArray.count {
            let gameType = ""
            let teamID = loaderArray[i].team_id
            let teamName = loaderArray[i].team!.name
            let rank = loaderArray[i].position
            let matches = loaderArray[i].played
            let points = loaderArray[i].points
            let won = loaderArray[i].won
            let countryImage = loaderArray[i].team!.image_path ?? "https://cdn.sportmonks.com/images/cricket/teams/10/10.png"

            let temp = RankRow(gameType: gameType, teamName: teamName!, rank: String(rank!), matches: String(matches!), points: String(points!), rating: String(won!), teamID: teamID!, teamImage: countryImage)

            data.append(temp)
        }

        return data
    }
}
