//
//  PreSavedDataSt.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import Foundation

class PreSavedDataSt {
    static let shared = PreSavedDataSt()
    private init() {}

    let suggestedPlayers: [PlayerMiniInfo] =
        [PlayerMiniInfo(id: 239, name: "Shakib Al Hasan", playerImg: "https://cdn.sportmonks.com/images/cricket/players/15/239.png", country: "", countryImg: "https://cdn.sportmonks.com/images/countries/png/short/bd.png"),
         PlayerMiniInfo(id: 46, name: "Virat Kohli", playerImg: "https://cdn.sportmonks.com/images/cricket/players/14/46.png", country: "", countryImg: "https://cdn.sportmonks.com/images/countries/png/short/in.png"),

         PlayerMiniInfo(id: 220, name: "Kane Williamson", playerImg: "https://cdn.sportmonks.com/images/cricket/players/28/220.png", country: "", countryImg: "https://cdn.sportmonks.com/images/countries/png/short/nz.png"),

         PlayerMiniInfo(id: 738, name: "David Warner", playerImg: "https://cdn.sportmonks.com/images/cricket/players/2/738.png", country: "", countryImg: "https://cdn.sportmonks.com/images/countries/png/short/au.png"),

         PlayerMiniInfo(id: 77, name: "Quinton de Kock", playerImg: "https://cdn.sportmonks.com/images/cricket/players/13/77.png", country: "", countryImg: "https://cdn.sportmonks.com/images/countries/png/short/za.png"),

         PlayerMiniInfo(id: 8, name: "Babar Azam", playerImg: "https://cdn.sportmonks.com/images/cricket/players/8/8.png", country: "", countryImg: "https://cdn.sportmonks.com/images/countries/png/short/pk.png")]

    let suggestedTeam: [TeamTiles] = [TeamTiles(id: 37, name: "Bangladesh", image: "https://cdn.sportmonks.com/images/countries/png/short/bd.png"),
                                      TeamTiles(id: 38, name: "England", image: "https://cdn.sportmonks.com/images/cricket/teams/6/38.png"),
                                      TeamTiles(id: 40, name: "South Africa", image: "https://cdn.sportmonks.com/images/cricket/teams/8/40.png"),
                                      TeamTiles(id: 42, name: "New Zealand", image: "https://cdn.sportmonks.com/images/cricket/teams/10/42.png"),
                                      TeamTiles(id: 61, name: "Dolphins", image: "https://cdn.sportmonks.com/images/cricket/teams/29/61.png"),
                                      TeamTiles(id: 65, name: "Knights", image: "https://cdn.sportmonks.com/images/cricket/teams/1/65.png")]

    let leagueList = [LeagueInfo(leagueID: 5, seasonID: 1079, leagueName: "Big Bash League", leagueImage: "https://cdn.sportmonks.com/images/cricket/leagues/5/5.png"), LeagueInfo(leagueID: 10, seasonID: 1145, leagueName: "CSA T20 Challenge", leagueImage: "https://cdn.sportmonks.com/images/cricket/leagues/10/10.png")]
}
