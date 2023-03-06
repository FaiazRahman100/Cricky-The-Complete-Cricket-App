//
//  UpcomingMatch.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import MapKit
import UIKit

class UpcomingMatch: UIViewController {
    @IBOutlet var loadingView: UIView!
    @IBOutlet var team1Image: UIImageView!
    @IBOutlet var team2Image: UIImageView!
    @IBOutlet var team1Name: UILabel!
    @IBOutlet var team2Name: UILabel!
    @IBOutlet var countDown: UILabel!
    @IBOutlet var seriesName: UILabel!
    @IBOutlet var roundName: UILabel!

    @IBOutlet var countdouwnBg: UIView!
    @IBOutlet var dateLabel: UILabel!

    @IBOutlet var team1Name2: UILabel!

    @IBOutlet var team2Name2: UILabel!

    @IBOutlet var venueName: UILabel!

    @IBOutlet var h2hBG: UIView!

    @IBOutlet var h2h1: UIView!

    @IBOutlet var h2h2: UIView!

    @IBOutlet var h2h3: UIView!

    @IBOutlet var h2h4: UIView!

    @IBOutlet var t1RecentMatch: UIView!

    @IBOutlet var venueBg: UIView!

    @IBOutlet var venue1: UIView!

    @IBOutlet var venue2: UIView!

    @IBOutlet var venue3: UIView!

    @IBOutlet var WPbg: UIView!

    @IBOutlet var WPBg1: UIView!
    @IBOutlet var team1Name3: UILabel!
    @IBOutlet var h2hTotal: UILabel!

    @IBOutlet var h2hteam1: UILabel!

    @IBOutlet var WPBg2: UIView!
    @IBOutlet var team2Name3: UILabel!

    @IBOutlet var h2hDraw: UILabel!
    @IBOutlet var h2hTeam2: UILabel!
    @IBOutlet var detailBg: UIView!

    @IBOutlet var h2hteam1Code: UILabel!
    @IBOutlet var h2hTeam2Code: UILabel!

    @IBOutlet var venueTM: UILabel!

    @IBOutlet var venueBat: UILabel!

    @IBOutlet var venueBall: UILabel!

    @IBOutlet var venueNR: UILabel!

    @IBOutlet var team1Name4: UILabel!
    @IBOutlet var team2Name4: UILabel!

    @IBOutlet var h2hBGM: UIView!
    @IBOutlet var t2RecenMatchVw: UIView!

    @IBOutlet var bgViews: [UIView]!

    @IBOutlet var team1rmLabel: [UILabel]!
    @IBOutlet var team1rmViews: [UIView]!

    @IBOutlet var team2rmLabel: [UILabel]!
    @IBOutlet var team2rmViews: [UIView]!

    @IBOutlet var team2Img2: UIImageView!
    @IBOutlet var team1Img2: UIImageView!
    @IBOutlet var venueImg: UIImageView!
    @IBOutlet var venueName2: UILabel!

    @IBOutlet var imageViewTicket: UIImageView!
    var viewModel = UpcomingMatchModel()
    var upcomingMatchData: UpcomingMatchAllData?

    @IBOutlet var team1WinRate: UILabel!

    @IBOutlet var team2WinRate: UILabel!
    @IBOutlet var bgViewTicket: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        countdouwnBg.layer.cornerRadius = 10
        detailBg.layer.cornerRadius = 20
        //   bgViews[0].layer.cornerRadius = 10
//        h2hBG.layer.cornerRadius = 10
//        h2hBG.clipsToBounds = true
        h2h1.layer.cornerRadius = 10
        h2h2.layer.cornerRadius = 10
        h2h3.layer.cornerRadius = 10
        h2h4.layer.cornerRadius = 10
        bgViewTicket.layer.cornerRadius = 10
        bgViewTicket.clipsToBounds = true
        imageViewTicket.layer.cornerRadius = 10
        venue1.layer.cornerRadius = 10
        venue2.layer.cornerRadius = 10
        venue3.layer.cornerRadius = 10
        venueBg.layer.cornerRadius = 10
        venueBg.clipsToBounds = true
        h2hBGM.layer.cornerRadius = 10
        h2hBGM.clipsToBounds = true
        WPbg.layer.cornerRadius = 10
        WPbg.clipsToBounds = true
        WPBg1.layer.cornerRadius = WPBg1.layer.frame.width / 2
        WPBg2.layer.cornerRadius = WPBg2.layer.frame.width / 2

        t1RecentMatch.layer.cornerRadius = 10
        t1RecentMatch.clipsToBounds = true
        t2RecenMatchVw.layer.cornerRadius = 10
        t2RecenMatchVw.clipsToBounds = true

        for view in team1rmViews {
            view.layer.cornerRadius = 5
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.alpha = 0.7
        }
        for view in team2rmViews {
            view.layer.cornerRadius = 5
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.alpha = 0.7
        }
        for label in team1rmLabel {
            label.text = "-"
        }
        for label in team2rmLabel {
            label.text = "-"
        }

        for view in bgViews {
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 1)
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 3
        }

        setupBinders()
    }

    func setupBinders() {
        viewModel.upcomingMatchAtoZ.bind(listener: { [weak self] responseFromModel in
            self?.upcomingMatchData = responseFromModel

            dump(responseFromModel)
            self?.updateUI()
        })
        viewModel.loadingComplete.bind(listener: { [weak self] _ in

            UIView.animate(withDuration: 1, animations: {
                self?.loadingView.alpha = 0
            }) { finished in
                if finished {
                    self?.loadingView.isHidden = true
                }
            }
        })
    }

    @IBAction func venueClicked(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }
        // Get the location name from some source (e.g. a text field)
        let locationName = upcomingMatchData?.venueStat.venueName

        // Create a map item for the location
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationName
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, _ in
            guard let response = response else { return }
            let mapItem = response.mapItems[0]

            // Open the Maps app and show the location
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }

    @IBAction func buyTicket(_: Any) {
        guard let url = URL(string: "https://www.cricket.com.au/tickets") else { return }
        UIApplication.shared.open(url)
    }

    @IBAction func team1Btn(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC {
            destinationVC.passedTeamID = upcomingMatchData?.team1Id

            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    @IBAction func team2Btn(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC {
            destinationVC.passedTeamID = upcomingMatchData?.team2Id

            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    func getWinningPercentage() -> (Int, Int) {
        let team1Score = (upcomingMatchData!.team1Stat.win * 2) + (upcomingMatchData!.team1Stat.draw * 1) +
            (upcomingMatchData!.head2head.teamAWin * 4)

        let team2Score = (upcomingMatchData!.team2Stat.win * 2) + (upcomingMatchData!.team2Stat.draw * 1) +
            (upcomingMatchData!.head2head.teamBWin * 4)
        let team1WinRate = Int(round(Double(team1Score) / Double(team1Score + team2Score) * 100))
        let team2WinRate = Int(round(Double(team2Score) / Double(team1Score + team2Score) * 100))

        return (team1WinRate, team2WinRate)
    }

    func updateUI() {
        var team1WinningRate = 0
        var team2WinningRate = 0

        (team1WinningRate, team2WinningRate) = getWinningPercentage()

        if team1WinningRate > team2WinningRate {
            WPBg2.backgroundColor = #colorLiteral(red: 0.2064709067, green: 0.208640486, blue: 0.3402027786, alpha: 1)
        } else {
            WPBg1.backgroundColor = #colorLiteral(red: 0.2064709067, green: 0.208640486, blue: 0.3402027786, alpha: 1)
        }

        team1WinRate.text = String(team1WinningRate) + "%"
        team2WinRate.text = String(team2WinningRate) + "%"

        let dateString = upcomingMatchData?.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        guard let date = dateFormatter.date(from: dateString!) else {
            fatalError("Invalid date string")
        }

        _ = UILabel()

        func updateTimeLeftLabel() {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute] // , .second]
            formatter.unitsStyle = .full
            formatter.zeroFormattingBehavior = .dropAll

            let timeLeftString = formatter.string(from: Date(), to: date)!
            countDown.text = "\(timeLeftString) Left"
        }

        updateTimeLeftLabel() // Update the label once initially

        // Create a timer to update the label every second
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTimeLeftLabel()
        }

        let url = URL(string: (upcomingMatchData?.team1Img)!)
        team1Image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        team1Img2.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))

        let url2 = URL(string: (upcomingMatchData?.team2Img)!)
        team2Image.sd_setImage(with: url2, placeholderImage: UIImage(named: "placeholder"))
        team2Img2.sd_setImage(with: url2, placeholderImage: UIImage(named: "placeholder"))

        let url3 = URL(string: (upcomingMatchData?.venueStat.venueImage)!)
        venueImg.sd_setImage(with: url3, placeholderImage: UIImage(named: "placeholder"))

        team1Image.layer.cornerRadius = team1Image.layer.frame.width / 2
        team2Image.layer.cornerRadius = team2Image.layer.frame.width / 2

        team1Name.text = upcomingMatchData?.team1Code
        team2Name.text = upcomingMatchData?.team2Code

        seriesName.text = upcomingMatchData?.stageName
        roundName.text = upcomingMatchData?.round
        dateLabel.text = upcomingMatchData?.time
        team1Name2.text = upcomingMatchData?.team1Name
        team2Name2.text = upcomingMatchData?.team2Name
        team1Name3.text = upcomingMatchData?.team1Name
        team2Name3.text = upcomingMatchData?.team2Name
        h2hDraw.text = String((upcomingMatchData?.head2head.h2hDraw)!)
        h2hTotal.text = String(upcomingMatchData!.head2head.totalGame)
        h2hteam1.text = String(upcomingMatchData!.head2head.teamAWin)
        h2hTeam2.text = String(upcomingMatchData!.head2head.teamBWin)
        h2hteam1Code.text = upcomingMatchData?.team1Code
        h2hTeam2Code.text = upcomingMatchData?.team2Code

        venueTM.text = "Total Matches: \(upcomingMatchData!.venueStat.totalMatches)"
        venueBat.text = String(upcomingMatchData!.venueStat.battingFirstWin)
        venueBall.text = String(upcomingMatchData!.venueStat.bowlingFirstWin)
        venueNR.text = String((upcomingMatchData!.venueStat.totalMatches) - (upcomingMatchData!.venueStat.battingFirstWin + upcomingMatchData!.venueStat.bowlingFirstWin))

        team1Name4.text = upcomingMatchData!.team1Name + "- Recent Matches"
        team2Name4.text = upcomingMatchData!.team2Name + "- Recent Matches"

        venueName.text = (upcomingMatchData?.venueStat.venueName)! + ", " + (upcomingMatchData?.venueStat.venueCity)!
        venueName2.text = (upcomingMatchData?.venueStat.venueName)! + ", " + (upcomingMatchData?.venueStat.venueCity)!

//        upcomingMatchData?.team1Stat.last10Match.count

        for i in 0 ..< (upcomingMatchData?.team1Stat.last10Match.count)! {
            if i < 8 {
                if upcomingMatchData?.team1Stat.last10Match[i] == "W" {
                    team1rmLabel[i].text = "W"
                    team1rmViews[i].backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
                } else if upcomingMatchData?.team1Stat.last10Match[i] == "L" {
                    team1rmLabel[i].text = "L"
                    team1rmViews[i].backgroundColor = #colorLiteral(red: 0.9686407343, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                } else {
                    team1rmLabel[i].text = "D"
                    team1rmViews[i].backgroundColor = #colorLiteral(red: 0.9686407343, green: 0.7492919715, blue: 0.478254838, alpha: 1)
                }
            }
        }
//
        for i in 0 ..< (upcomingMatchData?.team2Stat.last10Match.count)! {
            if i < 8 {
                if upcomingMatchData?.team2Stat.last10Match[i] == "W" {
                    team2rmLabel[i].text = "W"
                    team2rmViews[i].backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
                } else if upcomingMatchData?.team2Stat.last10Match[i] == "L" {
                    team2rmLabel[i].text = "L"
                    team2rmViews[i].backgroundColor = #colorLiteral(red: 0.9686407343, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                } else {
                    team2rmLabel[i].text = "D"
                    team2rmViews[i].backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
            }
        }
    }
}
