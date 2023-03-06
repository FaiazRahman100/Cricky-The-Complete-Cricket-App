//
//  SeriesViewModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 19/2/23.
//

import Foundation

class SeriesViewModel {
    var seriesList: ObservableObject<[SeriesInfo]?> = ObservableObject(nil)

    var loadingComplete: ObservableObject<Bool?> = ObservableObject(nil)

    // var matchList : [MatchTiles] = []
    var seriesListLoader: [SeriesInfo] = []

    func downloadSeries() {
        var data: [Stages] = []

        let apiToken = Constant.Key
        let baseUrl = Constant.baseUrl
        let seasonId = "1058"
        let include = "fixtures.localteam,fixtures.visitorteam"

        let link = APIQueryBuilder(baseUrl: baseUrl)
            .setEndpoint("/stages")
            .addQueryParam(key: "api_token", value: apiToken)
            .addQueryParam(key: "filter[season_id]", value: seasonId)
            .addIncludeParam(include)
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [weak self] (result: Result<StageStructure, Error>) in
            switch result {
            case let .success(response):
                data = response.data
                process()

                self?.seriesList.value = self?.seriesListLoader

                debugPrint("We got a successful result with stages")
            case let .failure(error):
                self?.loadingComplete.value = false
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
        func process() {
            for i in 0 ..< data.count {
                let name = data[i].name!
                let stage = data[i].id!
                let league = data[i].league_id!
                let season = data[i].season_id!

                let temp = SeriesInfo(name: name, stageID: stage, leagueID: league, seasonID: season)

                seriesListLoader.append(temp)
            }
            loadingComplete.value = true
        }
    }
}
