//
//  TeamVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 25/2/23.
//

import UIKit

class TeamVC: UIViewController {
    @IBOutlet var teamImage: UIImageView!

    @IBOutlet var teamImage2: UIImageView!

    @IBOutlet var teamName: UILabel!
    @IBOutlet var teamType: UILabel!

    @IBOutlet var searchBtn: UIButton!

    @IBOutlet var loadingView: UIView!
    var viewModel = TeamViewModel()
    var passedTeamID: Int?
    var teamData: TeamsData?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getTeamData(teamId: passedTeamID!)
        setupBinders()
    }

    func setupBinders() {
        viewModel.teamData.bind(listener: { [weak self] allData in
            self?.teamData = allData
            self?.updateUi()
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

    func updateUi() {
        let url = URL(string: (teamData?.image_path)!)
        teamImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        teamImage2.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        teamName.text = teamData?.name
        teamImage.layer.cornerRadius = teamImage.layer.frame.width / 2
        searchBtn.layer.cornerRadius = 10

        if teamData!.national_team {
            teamType.text = "National Team"
        } else {
            teamType.text = "Domestic Team"
        }
    }

    @IBAction func seeFixtureBtn(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Matches") as? Matches {
            let apiToken = Constant.Key
            let baseUrl = Constant.baseUrl
            let teamID = passedTeamID!
            let include = "stage,localteam,visitorteam,tosswon,runs.team"

            let link = APIQueryBuilder(baseUrl: baseUrl)
                .setEndpoint("/fixtures")
                .addQueryParam(key: "api_token", value: apiToken)
                .addQueryParam(key: "sort", value: "-starting_at")
                .addQueryParam(key: "filter[visitorteam_id]", value: String(teamID))
                .addIncludeParam(include)
                .build()

            destinationVC.passedLink = link
            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
