//
//  PlayerInfoVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import SDWebImage
import UIKit

class PlayerInfoVC: UIViewController {
    @IBOutlet var playerImage: UIImageView!

    @IBOutlet var playerCountryImage: UIImageView!

    @IBOutlet var playerCountryName: UILabel!

    @IBOutlet var tableViewX: UITableView!
    @IBOutlet var playerName2: UILabel!
    @IBOutlet var playerName1: UILabel!

    @IBOutlet var playerDob: UILabel!

    @IBOutlet var PlayerPosition: UILabel!

    @IBOutlet var battingStyle: UILabel!

    @IBOutlet var bowlingStyle: UILabel!

    @IBOutlet var detailbgView: UIView!

    @IBOutlet var bgView: UIView!

    @IBOutlet var bgView2: UIView!
    var tableArray = [playingTeam]()

    var viewModel = PlayerInfoVM()
    var playerInfoData: playerAllInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewX.delegate = self
        tableViewX.dataSource = self
        setupBinders()

        // Do any additional setup after loading the view.
    }

    func setupBinders() {
        viewModel.playerData.bind(listener: { [self] playerDataX in
            playerInfoData = playerDataX
            tableArray = playerDataX!.playingTeams
            DispatchQueue.main.async { [self] in
                tableViewX.reloadData()
            }
            updateOutlets()
        })
    }

    func updateOutlets() {
        let url = URL(string: (playerInfoData?.image) ?? "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png")
        playerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))

        let url2 = URL(string: (playerInfoData?.playerCountryImage) ?? "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png")
        playerCountryImage.sd_setImage(with: url2, placeholderImage: UIImage(named: "placeholder"))

        playerCountryName.text = playerInfoData?.playerCountry
        playerImage.layer.cornerRadius = playerImage.layer.frame.width / 2
        playerName1.text = playerInfoData?.name
        playerName2.text = playerInfoData?.name
        playerDob.text = playerInfoData?.dob
        PlayerPosition.text = playerInfoData?.position
        battingStyle.text = (playerInfoData?.battingStyle)?.capitalized
        bowlingStyle.text = (playerInfoData?.bowlingStyle)?.capitalized

        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true

        bgView2.layer.cornerRadius = 10
        bgView2.clipsToBounds = true
    }
}
