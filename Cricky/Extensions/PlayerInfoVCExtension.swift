//
//  PlayerInfoVCExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import Foundation
import UIKit

extension PlayerInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "PlayingTeams", for: indexPath) as! PlayingTeams

        cell.teamName.text = tableArray[indexPath.row].name
        let url = URL(string: tableArray[indexPath.row].image)
        cell.teamImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewX.deselectRow(at: indexPath, animated: true)

        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC {
            destinationVC.passedTeamID = tableArray[indexPath.row].id

            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
