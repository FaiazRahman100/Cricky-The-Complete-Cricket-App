//
//  LZPagingMatchInfoVC.swift
//  Cricky
//
//  Created by bjit on 20/2/23.
//

import LZViewPager
import UIKit

class LZPagingMatchInfoVC: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    @IBOutlet var viewPager: LZViewPager!

    var fixtureID: Int?
    var selectedGame: Datum?
    var everyThingMatch: MatchAllDetails?
    var teamList: [TeamX]?

    @IBOutlet var loadingView: UIView!

    // MARK: Variable

    private var subControllers: [UIViewController] = []

    let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchDetails") as! MatchDetails

    let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScoreboardVC") as! ScoreboardVC

    let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SquadVC") as! SquadVC

    override func viewDidLoad() {
        super.viewDidLoad()
        // viewPagerProperties()
        downloadFixtures(fixtureID: fixtureID!)
        // Do any additional setup after loading the view.
    }

    // MARK: Property

    func viewPagerProperties() {
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self

        vc1.loadViewIfNeeded()
        vc2.loadViewIfNeeded()
        vc3.loadViewIfNeeded()
        vc1.viewModel.matchData.value = everyThingMatch
        vc2.viewModel.passedGame = selectedGame
        vc3.viewModel.teamList.value = teamList
        vc1.title = "Match Info"
        vc2.title = "Scoreboard"
        vc3.title = "Squad"
        subControllers = [vc1, vc2, vc3]
        viewPager.reload()
    }

    // MARK: Action

    func numberOfItems() -> Int {
        subControllers.count
    }

    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }

    func button(at _: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 0.2065195143, green: 0.2087805867, blue: 0.34461537, alpha: 1)
        return button
    }

    func downloadFixtures(fixtureID: Int) {
        let builder = APIQueryBuilder(baseUrl: Constant.baseUrl)
        let link = builder.setEndpoint("/fixtures/\(fixtureID)")
            .addQueryParam(key: "api_token", value: "8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR")
            .addQueryParam(key: "sort", value: "-starting_at")
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
            .addIncludeParam("firstumpire")
            .addIncludeParam("secondumpire")
            .build()

        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [weak self] (result: Result<SelectedFixture, Error>) in
            switch result {
            case let .success(response):
                self?.selectedGame = response.data

                process()

                debugPrint("We got a successful result with selected fixture.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }

        func process() {
            var noteZ = selectedGame?.note ?? ""
            let inputString = selectedGame?.note

            if inputString!.contains("balls remaining") {
                let pattern = "\\s*\\(.*\\)$" // matches the last parentheses and its contents
                let regex = try! NSRegularExpression(pattern: pattern)
                let range = NSRange(location: 0, length: inputString!.count)
                let outputString = regex.stringByReplacingMatches(in: inputString!, options: [], range: range, withTemplate: "")

                noteZ = outputString
            } else {
                noteZ = inputString!
            }
            let time = getConvertedTime(selectedGame!.starting_at!)
            var team1Score = ""
            var team1Over = ""
            var team1Code = (selectedGame?.localteam?.code)!
            var team1Name = (selectedGame?.localteam?.name)!
            var team1ID = (selectedGame?.localteam?.id)!

            var team2Score = ""
            var team2Over = ""
            var team2Code = (selectedGame?.visitorteam?.code)!
            var team2Name = (selectedGame?.visitorteam?.name)!
            var team2ID = (selectedGame?.visitorteam?.id)!

            var team1Image = (selectedGame?.localteam?.image_path)!
            var team2Image = (selectedGame?.visitorteam?.image_path)!

            if selectedGame?.runs?.count == 2 {
                team1Score = String(selectedGame?.runs?[0].score ?? 0) + "-" + String(selectedGame?.runs?[0].wickets ?? 0)
                team1Over = String(selectedGame?.runs?[0].overs ?? 0)
                team1Over = "(\(team1Over))"
                team1Code = (selectedGame?.runs?[0].team?.code)!
                team1Image = (selectedGame?.runs?[0].team?.image_path)!
                team1ID = (selectedGame?.runs?[0].team?.id)!
                team1Name = (selectedGame?.runs?[0].team?.name)!
                team2Name = (selectedGame?.runs?[1].team?.name)!

                team2Score = String(selectedGame?.runs?[1].score ?? 0) + "-" + String(selectedGame?.runs?[1].wickets ?? 0)
                team2Over = String(selectedGame?.runs?[1].overs ?? 0)
                team2Over = "(\(team2Over))"
                team2Code = (selectedGame?.runs?[1].team?.code)!
                team2Image = (selectedGame?.runs?[1].team?.image_path)!
                team2ID = (selectedGame?.runs?[1].team?.id)!

            } else if selectedGame?.runs?.count == 1 {
                team1Code = (selectedGame?.runs?[0].team?.code)!
                team1Score = String(selectedGame?.runs?[0].score ?? 0) + "-" + String(selectedGame?.runs?[0].wickets ?? 0)
                team1Over = String(selectedGame?.runs?[0].overs ?? 0)
                team1Over = "(\(team1Over))"
                team1Image = (selectedGame?.runs?[0].team?.image_path)!
                team1ID = (selectedGame?.runs?[0].team?.id)!

                team2Score = "0-0"
                team2Over = "(0.0)"
                if team1Code != (selectedGame?.localteam?.code)! {
                    team2Code = (selectedGame?.localteam?.code)!
                    team2Image = (selectedGame?.localteam?.image_path)!
                    team2Name = (selectedGame?.localteam?.name)!
                    team2ID = (selectedGame?.localteam_id)!
                } else {
                    team2Code = (selectedGame?.visitorteam?.code)!
                    team2Image = (selectedGame?.visitorteam?.image_path)!
                    team2Name = (selectedGame?.visitorteam?.name)!
                    team2ID = (selectedGame?.visitorteam_id)!
                }
            }

            let stageZ = selectedGame?.stage?.name
            let round = selectedGame?.round ?? ""

            let venue = selectedGame?.venue?.name ?? ""
            let venueCity = selectedGame?.venue?.city ?? ""
            let momID = selectedGame?.man_of_match_id ?? 239
            let momName = selectedGame?.manofmatch?.fullname ?? "Not Declared"
            let umpire1 = selectedGame?.firstumpire?.fullname ?? ""
            let umpire2 = selectedGame?.secondumpire?.fullname ?? ""
            let toss = (selectedGame?.tosswon?.name ?? "") + " elected " + (selectedGame?.elected ?? "batting")
            let venueImg = selectedGame?.venue?.image_path ?? "https://cdn.sportmonks.com/images/cricket/venues/4/132.png"

            var team1Squad: [PlayerIdentity] = []
            var team2Squad: [PlayerIdentity] = []

            for i in 0 ..< (selectedGame?.lineup!.count)! {
                let playerName = selectedGame?.lineup![i].fullname ?? "Faiaz Rahman"
                let playerId = selectedGame?.lineup![i].id ?? 0
                let playerImage = selectedGame?.lineup![i].image_path ?? ""
                let playerPosition = selectedGame?.lineup![i].position?.name ?? ""
                let temp = PlayerIdentity(id: playerId, name: playerName, image: playerImage, position: playerPosition)
                if i < 11 {
                    team1Squad.append(temp)
                } else {
                    team2Squad.append(temp)
                }
            }

            let team1 = TeamX(teamName: selectedGame?.localteam?.name ?? "India", playerList: team1Squad)
            let team2 = TeamX(teamName: (selectedGame?.visitorteam?.name) ?? "Srilanka", playerList: team2Squad)

            teamList = [team1, team2]
            dump(teamList)

            everyThingMatch = MatchAllDetails(team1Name: team1Name, team1Code: team1Code, team2Name: team2Name, team2Code: team2Code, team1Score: team1Score, team2Score: team2Score, team1Over: team1Over, team2Over: team2Over, result: noteZ, momName: momName, seriesName: stageZ!, round: round, date: time, umpire1: umpire1, umpire2: umpire2, toss: toss, venue: venue, venueCity: venueCity, team1ID: team1ID, team2ID: team2ID, momID: momID, team1Img: team1Image, team2Img: team2Image, venueImg: venueImg, momImage: (selectedGame?.manofmatch?.image_path) ?? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png")

            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.loadingView.alpha = 0
            }) { [weak self] finished in
                if finished {
                    self?.loadingView.isHidden = true
                }
            }

            viewPagerProperties()
        }
    }
}
