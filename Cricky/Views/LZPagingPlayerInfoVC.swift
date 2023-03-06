//
//  LZPagingPlayerInfoVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import LZViewPager
import UIKit

class LZPagingPlayerInfoVC: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    @IBOutlet var loadingView: UIView!
    @IBOutlet var viewPager: LZViewPager!
    private var subControllers: [UIViewController] = []
    let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerInfoVC") as! PlayerInfoVC
    let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerCareerVC") as! PlayerCareerVC
    let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerCareerVC") as! PlayerCareerVC

    var playerID: Int?
    var playerData: PlayerData?
    var bowlingData: [rowWiseRecord]?
    var battingData: [rowWiseRecord]?
    var playerAtoZ: playerAllInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPlayerCareer(id: playerID!)
    }

    func viewPagerProperties() {
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self

        vc1.loadViewIfNeeded()
        vc2.loadViewIfNeeded()
        vc3.loadViewIfNeeded()

        vc1.viewModel.playerData.value = playerAtoZ
        vc2.viewModel.careerStats.value = battingData
        vc3.viewModel.careerStats.value = bowlingData

        vc1.title = "Player Info"
        vc2.title = "Batting"
        vc3.title = "Bowling"
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

    func downloadPlayerCareer(id: Int) {
        let baseUrl = Constant.baseUrl + "/"
        let apiToken = Constant.Key

        let link = APIQueryBuilder(baseUrl: baseUrl)
            .setEndpoint("players/\(id)")
            .addQueryParam(key: "api_token", value: apiToken)
            .addIncludeParam("country")
            .addIncludeParam("career.season")
            .addIncludeParam("teams")
            .addIncludeParam("currentteams")
            .build()

        // Create the URL to fetch
        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [self] (result: Result<Player, Error>) in
            switch result {
            case let .success(response):
                playerData = response.data
                process()
            // debugPrint("We got a successful result with \(response.data) users.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }

        func process() {
            let (careerT20Bowl, careerT20Bat) = careerCalculation(gameType: "T20")
            let (careerT20IBowl, careerT20IBat) = careerCalculation(gameType: "T20I")
            let (careerODIBowl, careerODIBat) = careerCalculation(gameType: "ODI")
            let ballParamNames = ["Matches", "Innings", "Runs", "Balls", "Wickets", "Economy", "Five Wickets", "Ten_wickets", "Wide", "Noball", "Medians"]
            let batingParamNames = ["Matches", "Innings", "Runs", "Balls", "Fifties", "Hundreds", "High Score", "Not Outs", "Four", "Six", "Strikes Rate"]
            var bowlingDataTemp: [rowWiseRecord] = []
            var battingDataTemp: [rowWiseRecord] = []

            let headerRow = rowWiseRecord(name: "BOWLING", t20: "Domestic", t20I: "T20I", odi: "ODI")
            bowlingDataTemp.append(headerRow)

            for i in 0 ..< ballParamNames.count {
                if ballParamNames[i] == "Economy" {
                    let temp = rowWiseRecord(name: ballParamNames[i], t20: String(format: "%.2f", careerT20Bowl[i]), t20I: String(format: "%.2f", careerT20IBowl[i]), odi: String(format: "%.2f", careerODIBowl[i]))
                    bowlingDataTemp.append(temp)
                    continue
                }

                let temp = rowWiseRecord(name: ballParamNames[i], t20: String(Int(careerT20Bowl[i])), t20I: String(Int(careerT20IBowl[i])), odi: String(Int(careerODIBowl[i])))

                bowlingDataTemp.append(temp)
            }
            dump(bowlingDataTemp)
            let headerRowBat = rowWiseRecord(name: "BATTING", t20: "Domestic", t20I: "T20I", odi: "ODI")
            battingDataTemp.append(headerRowBat)

            for i in 0 ..< batingParamNames.count {
                if batingParamNames[i] == "Strikes Rate" {
                    let temp = rowWiseRecord(name: batingParamNames[i], t20: String(format: "%.2f", careerT20Bat[i]), t20I: String(format: "%.2f", careerT20IBat[i]), odi: String(format: "%.2f", careerODIBat[i]))
                    battingDataTemp.append(temp)
                    continue
                }

                let temp = rowWiseRecord(name: batingParamNames[i], t20: String(Int(careerT20Bat[i])), t20I: String(Int(careerT20IBat[i])), odi: String(Int(careerODIBat[i])))

                battingDataTemp.append(temp)
            }

            // extract player carrer Data
            let name = playerData?.fullname ?? ""
            let image = playerData?.image_path ?? "https://cdn.sportmonks.com/images/cricket/players/15/239.png"
            let position = playerData?.position?.name ?? "batsman"
            let dob = playerData?.dateofbirth ?? "09/04/1999"
            let battingStyle = playerData?.battingstyle ?? "Left Handed"
            let bowlingStyle = playerData?.bowlingstyle ?? "Never Bowled"

            var teamName: [String] = []
            var teamPlayedFor: [playingTeam] = []
            for i in 0 ..< (playerData?.teams!.count)! {
                let name = playerData?.teams![i].name ?? "Bravo Dawyne"
                if teamName.contains(name) {
                    continue
                } else {
                    let image = playerData?.teams![i].image_path ?? "https://cdn.sportmonks.com/images/cricket/teams/5/37.png"

                    let id = playerData?.teams![i].id ?? 37
                    let temp = playingTeam(id: id, name: name, image: image)
                    teamPlayedFor.append(temp)
                    teamName.append(name)
                }
            }
            let playerCountry = playerData?.country?.name ?? "Uganda"
            let playerCountryImage = playerData?.country?.image_path ?? "https://cdn.sportmonks.com/images/countries/png/short/au.png"

            bowlingData = bowlingDataTemp
            battingData = battingDataTemp

            playerAtoZ = playerAllInfo(name: name, image: image, position: position, dob: dob, battingStyle: battingStyle, bowlingStyle: bowlingStyle, playingTeams: teamPlayedFor, playerCountry: playerCountry, playerCountryImage: playerCountryImage)

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

    func careerCalculation(gameType: String) -> ([Double], [Double]) {
        let careerCount = playerData?.career?.count

        let ballParams = ["matches", "innings", "runs", "overs", "wickets", "econ_rate", "five_wickets", "ten_wickets", "wide", "noball", "medians"]
        let batingParams = ["matches", "innings", "runs_scored", "balls_faced", "fifties", "hundreds", "highest_inning_score", "not_outs", "four_x", "six_x", "strike_rate"]

        var paramCounterBowl: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var paramCounterBatting: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var bowledCount = 0
        var battingCount = 0
        var highScore = 0

        for i in 0 ..< careerCount! {
            if playerData?.career?[i].type == gameType {
                if let value = playerData?.career![i].bowling {
                    bowledCount += 1
                    for j in 0 ..< paramCounterBowl.count {
                        if j == 3 {
                            var over = floor(value[ballParams[j]]!!)
                            var ball = value[ballParams[j]]!! - over
                            var totalBall = over * 6 + ball * 10
                            paramCounterBowl[j] += totalBall
                            continue
                        }
                        paramCounterBowl[j] += value[ballParams[j]]! ?? 0
                    }
                }

                if let value2 = playerData?.career![i].batting {
                    battingCount += 1
                    for j in 0 ..< paramCounterBatting.count {
                        if j == 6 {
                            let currentHighScore = Int(value2[batingParams[j]]!!)

                            if highScore <= currentHighScore {
                                highScore = currentHighScore
                                paramCounterBatting[j] = Double(highScore)
                            }
                            continue
                        }

                        paramCounterBatting[j] += value2[batingParams[j]]! ?? 0
                    }
                }
            }
            if i == careerCount! - 1 {
                paramCounterBowl[5] = paramCounterBowl[5] / Double(bowledCount)
                bowledCount = 0

                paramCounterBatting[10] = paramCounterBatting[10] / Double(battingCount)
            }
        }
        return (paramCounterBowl, paramCounterBatting)
    }
}
