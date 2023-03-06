//
//  MatchDetails.swift
//  Cricky
//
//  Created by Faiaz Rahman on 19/2/23.
//

import MapKit
import SDWebImage
import UIKit

class MatchDetails: UIViewController {
    @IBOutlet var bgViews: [UIView]!

    @IBOutlet var stadiumBg: UIView!
    @IBOutlet var momImage: UIImageView!
    @IBOutlet var team1Img: UIImageView!
    @IBOutlet var team2Img: UIImageView!
    @IBOutlet var team1Score: UILabel!
    @IBOutlet var team2Score: UILabel!
    @IBOutlet var team1Over: UILabel!
    @IBOutlet var team2Over: UILabel!
    @IBOutlet var team2Name: UILabel!
    @IBOutlet var team1Name: UILabel!
    @IBOutlet var resultLabel: UILabel!

    @IBOutlet var venueImageTop: UIImageView!

    @IBOutlet var momName: UILabel!
    var momID: Int?

    @IBOutlet var seriesName: UILabel!
    @IBOutlet var roundName: UILabel!
    @IBOutlet var matchTime: UILabel!
    @IBOutlet var TossResult: UILabel!
    @IBOutlet var venueImg: UIImageView!
    @IBOutlet var venueName: UILabel!
    @IBOutlet var venueCity: UILabel!

    @IBOutlet var imageBgView: UIView!
    @IBOutlet var team1NameD: UILabel!
    @IBOutlet var team2NameD: UILabel!
    @IBOutlet var Umpire1D: UILabel!
    @IBOutlet var Umpire2D: UILabel!

    var viewModel = MatchDetailModel()

    var matchData: MatchAllDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinders()
    }

    func setupBinders() {
        viewModel.matchData.bind(listener: { [weak self] matchDataX in
            dump(matchDataX)
            self?.matchData = matchDataX
            self?.updateOutlets()
        })
    }

    @IBAction func momClicked(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }
        if matchData?.momName != "Not Declared" {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingPlayerInfoVC") as? LZPagingPlayerInfoVC {
                destinationVC.playerID = matchData?.momID
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }

    @IBAction func team1Clicked(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC {
            destinationVC.passedTeamID = matchData?.team1ID

            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    @IBAction func team2Clicked(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC {
            destinationVC.passedTeamID = matchData?.team2ID

            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    @IBAction func venueClicked(_: Any) {
        let locationName = matchData?.venue
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }
        // Create a map item for the location
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationName
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, _ in
            guard let response = response else { return }
            let mapItem = response.mapItems[0]

            // Open the Maps app and show the location
            mapItem.openInMaps(launchOptions: [:])
        }
    }

    func updateOutlets() {
        for view in bgViews {
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 1)
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 3
        }
        imageBgView.layer.cornerRadius = 10
        venueImg.layer.cornerRadius = 10
        team1Img.layer.cornerRadius = 10
        team2Img.layer.cornerRadius = 10
        stadiumBg.layer.cornerRadius = 10
        venueImg.layer.shadowOpacity = 0.2
        team1Score.text = matchData?.team1Score
        team1Over.text = matchData?.team1Over
        team2Score.text = matchData?.team2Score
        team2Over.text = matchData?.team2Over
        team1Name.text = matchData?.team1Code
        team2Name.text = matchData?.team2Code

        resultLabel.text = matchData?.result
        momName.text = matchData?.momName
        seriesName.text = matchData?.seriesName
        roundName.text = matchData?.round
        matchTime.text = matchData?.date
        TossResult.text = matchData?.toss
        team1NameD.text = matchData?.team1Name
        team2NameD.text = matchData?.team2Name
        Umpire1D.text = matchData?.umpire1
        Umpire2D.text = matchData?.umpire2

        let urlVenue = URL(string: matchData!.venueImg)
        venueImg.sd_setImage(with: urlVenue, placeholderImage: UIImage(named: "placeholder"))
        venueImageTop.sd_setImage(with: urlVenue, placeholderImage: UIImage(named: "placeholder"))

        let url1 = URL(string: (matchData?.team1Img)!)
        team1Img.sd_setImage(with: url1, placeholderImage: UIImage(named: "placeholder"))

        let url2 = URL(string: (matchData?.team2Img)!)
        team2Img.sd_setImage(with: url2, placeholderImage: UIImage(named: "placeholder"))

        let url3 = URL(string: (matchData?.momImage)!)
        momImage.sd_setImage(with: url3, placeholderImage: UIImage(named: "placeholder"))
        momImage.layer.cornerRadius = momImage.frame.width / 2

        venueName.text = matchData?.venue
        venueCity.text = matchData?.venueCity
    }
}
