//
//  TeamViewModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 25/2/23.
//

import Foundation

class TeamViewModel {
    var teamData: ObservableObject<TeamsData?> = ObservableObject(nil)

    var loadingComplete: ObservableObject<Bool?> = ObservableObject(nil)

    func getTeamData(teamId: Int) {
        let apiToken = Constant.Key
        let baseUrl = Constant.baseUrl
        let teamID = teamId

        let link = APIQueryBuilder(baseUrl: baseUrl)
            .setEndpoint("/teams/\(teamID)")
            .addQueryParam(key: "api_token", value: apiToken)
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [weak self] (result: Result<CertainTeam, Error>) in
            switch result {
            case let .success(response):
                self?.loadingComplete.value = true
                self?.teamData.value = response.data

                debugPrint("We got a successful result with Team Data.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
    }
}
