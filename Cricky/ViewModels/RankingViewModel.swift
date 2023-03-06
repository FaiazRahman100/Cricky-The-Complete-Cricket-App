//
//  RankingViewModel.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import Foundation

class RankingViewModel {
    var tableArray: ObservableObject<[RankRow]?> = ObservableObject(nil)

    var loaderArray: [MatchType] = []
    var loadingComplete: ObservableObject<Bool?> = ObservableObject(nil)
    var testRanking: [RankRow] = []
    var t20iRanking: [RankRow] = []
    var odiRanking: [RankRow] = []

//    var tableArray: [RankRow] = []

    func t20Selected() {
        tableArray.value = t20iRanking
    }

    func odiSelected() {
        tableArray.value = odiRanking
    }

    func testSelected() {
        tableArray.value = testRanking
    }

    func requestApi() {
        let apiToken = Constant.Key
        let baseUrl = Constant.baseUrl

        let link = APIQueryBuilder(baseUrl: baseUrl)
            .setEndpoint("/team-rankings")
            .addQueryParam(key: "api_token", value: apiToken)
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [self] (result: Result<TeamRanks, Error>) in
            switch result {
            case let .success(response):
                loaderArray = response.data

                processData()

                debugPrint("We got a successful result with \(response.data.count) ranks.")
            case let .failure(error):
                self.loadingComplete.value = false
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
    }

    func processData() {
        testRanking = getRanking(gameType: "TEST")
        t20iRanking = getRanking(gameType: "T20I")
        odiRanking = getRanking(gameType: "ODI")

        tableArray.value = t20iRanking
        // dump(t20iRanking)
        loadingComplete.value = true
    }

    func getRanking(gameType: String) -> [RankRow] {
        var data: [RankRow] = []

        let headerRow = RankRow(gameType: gameType, teamName: "Country", rank: "Rank", matches: "M", points: "Points", rating: "Rating", teamID: 0, teamImage: "")
        data.append(headerRow)

        for i in 0 ..< loaderArray.count {
            if loaderArray[i].type == gameType && loaderArray[i].gender == "men" {
                for j in 0 ..< loaderArray[i].team!.count {
                    let gameType = loaderArray[i].type
                    let teamID = loaderArray[i].team![j].id
                    let teamName = loaderArray[i].team![j].name
                    let rank = loaderArray[i].team![j].ranking?.position
                    let matches = loaderArray[i].team![j].ranking?.matches
                    let points = loaderArray[i].team![j].ranking?.points
                    let rating = loaderArray[i].team![j].ranking?.rating
                    let countryImage = loaderArray[i].team![j].image_path ?? "https://cdn.sportmonks.com/images/cricket/teams/10/10.png"

                    let temp = RankRow(gameType: gameType!, teamName: teamName!, rank: String(rank!), matches: String(matches!), points: String(points!), rating: String(rating!), teamID: teamID!, teamImage: countryImage)

                    data.append(temp)
                }
            }
        }
        return data
    }
}
