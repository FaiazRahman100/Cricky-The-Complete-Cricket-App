//
//  RankingVCExtension.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import Foundation
import UIKit

extension RankingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingCell

        cell.bgView.backgroundColor = .white

        if indexPath.row == 0 {
            cell.bgView.backgroundColor = #colorLiteral(red: 0.5326756239, green: 0.7550755143, blue: 0.8370990753, alpha: 1)
        }

        cell.rank.text = tableArray[indexPath.row].rank

        let url = URL(string: tableArray[indexPath.row].teamImage)
        cell.teamImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        cell.countryName.text = tableArray[indexPath.row].teamName
        cell.matches.text = tableArray[indexPath.row].matches
        cell.points.text = tableArray[indexPath.row].points
        cell.rating.text = tableArray[indexPath.row].rating

        cell.bgView.layer.cornerRadius = 10
        cell.bgView.layer.masksToBounds = false
        cell.bgView.layer.shadowColor = UIColor.black.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.bgView.layer.shadowOpacity = 0.1
        cell.bgView.layer.shadowRadius = 3

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewX.deselectRow(at: indexPath, animated: true)

        guard indexPath.row != 0 else { return }

        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TeamVC") as? TeamVC {
            destinationVC.passedTeamID = tableArray[indexPath.row].teamID
            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}
