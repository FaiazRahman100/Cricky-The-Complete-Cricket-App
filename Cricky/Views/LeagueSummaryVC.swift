//
//  LeagueSummaryVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 24/2/23.
//

import UIKit

class LeagueSummaryVC: UIViewController {
    @IBOutlet var motherBg: UIView!
    @IBOutlet var leagueImage: UIImageView!

    @IBOutlet var loadingView: UIView!
    @IBOutlet var leagueName: UILabel!
    @IBOutlet var bgViews: [UIView]!

    @IBOutlet var totalMatches: UILabel!
    @IBOutlet var highInningsPlayerImgs: UIImageView!
    @IBOutlet var mostWicketPlayerImg: UIImageView!

    @IBOutlet var mostRunPlayerImg: UIImageView!

    @IBOutlet var bestBowlingPlayerImg: UIImageView!

    @IBOutlet var highInnPlayerName: UILabel!

    @IBOutlet var hiInnPlayerRun: UILabel!

    @IBOutlet var highInnPlayerId: UILabel!

    @IBOutlet var mostWplayerName: UILabel!

    @IBOutlet var mostWPlayerWicket: UILabel!

    @IBOutlet var mostWPlayerTeam: UILabel!

    @IBOutlet var mostRunPlayrName: UILabel!

    @IBOutlet var mostRunPlayerRun: UILabel!

    @IBOutlet var mostRunPlayerCoutry: UILabel!

    @IBOutlet var bestBowlingPlayerName: UILabel!

    @IBOutlet var bestBowlingPlayerScore: UILabel!

    @IBOutlet var bestBowlingPlayerTeam: UILabel!

    var insights: LeagueStatistics?

    var viewModel = LeagueSummaryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinders()
    }

    func setupBinders() {
        viewModel.allSummary.bind(listener: { [weak self] allData in
            self?.insights = allData
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

    func updateUI() {
        motherBg.layer.cornerRadius = 20
        for view in bgViews {
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 1)
            view.layer.shadowOpacity = 0.5
            view.layer.shadowRadius = 3
        }

        highInningsPlayerImgs.layer.cornerRadius = highInningsPlayerImgs.layer.frame.width / 2
        mostWicketPlayerImg.layer.cornerRadius = mostWicketPlayerImg.layer.frame.width / 2
        mostRunPlayerImg.layer.cornerRadius = mostRunPlayerImg.layer.frame.width / 2
        bestBowlingPlayerImg.layer.cornerRadius = bestBowlingPlayerImg.layer.frame.width / 2

        let url = URL(string: (insights?.leagueImage)!)
        leagueImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        let url2 = URL(string: (insights?.highestRunPlayerImage)!)
        highInningsPlayerImgs.sd_setImage(with: url2, placeholderImage: UIImage(named: "placeholder"))
        let url3 = URL(string: (insights?.mostWicketPlayerImage)!)
        mostWicketPlayerImg.sd_setImage(with: url3, placeholderImage: UIImage(named: "placeholder"))
        let url4 = URL(string: (insights?.mostRunPlayerImage)!)
        mostRunPlayerImg.sd_setImage(with: url4, placeholderImage: UIImage(named: "placeholder"))
        let url5 = URL(string: (insights?.bestBowlingPlayerImage)!)
        bestBowlingPlayerImg.sd_setImage(with: url5, placeholderImage: UIImage(named: "placeholder"))

        leagueName.text = insights?.leagueName
        totalMatches.text = "Total Matches: \(insights!.totalMatches)"
        highInnPlayerName.text = insights?.highestRunPlayerName
        highInnPlayerId.text = insights?.highestRunPlayerTeamName
        hiInnPlayerRun.text = "Run: \(insights!.highestRun) (\(insights!.highestRunBall))"

        mostWplayerName.text = insights?.mostWicketPlayerName
        mostWPlayerWicket.text = "Total Wicket: \(insights!.mostWicket)"
        mostWPlayerTeam.text = insights?.mostWicketPlayerTeam

        mostRunPlayrName.text = insights?.mostRunPlayerName
        mostRunPlayerRun.text = "Total Run: \(insights!.mostRun)"
        mostRunPlayerCoutry.text = insights?.mostRunPlayerTeam

        bestBowlingPlayerName.text = insights?.bestBowlingPlayerName
        bestBowlingPlayerScore.text = "Economy Rate: \(insights!.bestBowlingRun)"
        bestBowlingPlayerTeam.text = insights?.bestBowlingTeam
    }

    @IBAction func highRunBtn(_: Any) {
        gotToPlayerInfo(playerId: insights!.highestRunPlayedID)
    }

    @IBAction func mostWicketBtn(_: Any) {
        gotToPlayerInfo(playerId: insights!.mostWicketPlayerID)
    }

    @IBAction func MostRunBtn(_: Any) {
        gotToPlayerInfo(playerId: insights!.mostRunPlayedID)
    }

    @IBAction func BestBowlingBtn(_: Any) {
        gotToPlayerInfo(playerId: insights!.bestBowlingPlayerID)
    }

    func gotToPlayerInfo(playerId: Int) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingPlayerInfoVC") as? LZPagingPlayerInfoVC {
            destinationVC.playerID = playerId
            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
