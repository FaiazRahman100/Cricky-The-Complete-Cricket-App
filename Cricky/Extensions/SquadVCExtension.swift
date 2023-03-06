//
//  SquadVCExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 20/2/23.
//

import Foundation
import UIKit

extension SquadVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "PlayerListCell", for: indexPath) as! PlayerListCell
        cell.playerName.text = tableArray[indexPath.row].name
        cell.playerPosition.text = tableArray[indexPath.row].position

        cell.playerImage.layer.cornerRadius = cell.playerImage.frame.size.width / 2
        cell.playerImage.clipsToBounds = true

        let url = URL(string: tableArray[indexPath.row].image)
        cell.playerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        cell.bgView.layer.masksToBounds = false
        cell.bgView.layer.shadowColor = UIColor.black.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.bgView.layer.shadowOpacity = 0.3
        cell.bgView.layer.shadowRadius = 3
        cell.bgView.layer.cornerRadius = 10

        let playerType = tableArray[indexPath.row].position
        if playerType == "Batsman" {
            cell.playerType.image = UIImage(named: "batting")
        } else if playerType == "Bowler" {
            cell.playerType.image = UIImage(named: "ball2")
        } else if playerType == "Allrounder" {
            cell.playerType.image = UIImage(named: "allrounder")
        } else {
            cell.playerType.image = UIImage(named: "helmet")
        }
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewX.deselectRow(at: indexPath, animated: true)

        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingPlayerInfoVC") as? LZPagingPlayerInfoVC {
            // destinationVC.viewModel.downloadFixture(fixtureID: tableArray[indexPath.row].fixtureID)
//                destinationVC.fixtureID = tableArray[indexPath.row].fixtureID
            destinationVC.playerID = tableArray[indexPath.row].id
            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    // bouncein

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}
