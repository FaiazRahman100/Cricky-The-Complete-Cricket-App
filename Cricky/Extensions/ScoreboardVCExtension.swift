//
//  ScoreboardVCExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import Foundation
import UIKit

extension ScoreboardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (tableArray?.battingStat.count)!
        } else {
            return (tableArray?.bowlingStat.count)!
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        2
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableViewX.dequeueReusableCell(withIdentifier: "BattingCell", for: indexPath) as! BattingCell

            cell.outStatus.text = tableArray?.battingStat[indexPath.row].outStatus

            cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            if indexPath.row == 0 {
                cell.bgView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.5764705882, blue: 0.2784313725, alpha: 1)
                cell.outStatusHeight.constant = 0
            }

            cell.outStatus.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            if tableArray?.battingStat[indexPath.row].outStatus == "Not Out" {
                cell.outStatus.textColor = #colorLiteral(red: 0.3294117647, green: 0.5764705882, blue: 0.2784313725, alpha: 1)
            }

            cell.batsmanName.text = tableArray?.battingStat[indexPath.row].playerName
            cell.run.text = tableArray?.battingStat[indexPath.row].score
            cell.ball.text = tableArray?.battingStat[indexPath.row].ball
            cell.four.text = tableArray?.battingStat[indexPath.row].four
            cell.six.text = tableArray?.battingStat[indexPath.row].six
            cell.sR.text = tableArray?.battingStat[indexPath.row].srikeRate
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.layer.masksToBounds = false
            cell.bgView.layer.shadowColor = UIColor.black.cgColor
            cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.bgView.layer.shadowOpacity = 0.2
            cell.bgView.layer.shadowRadius = 3
            return cell
        } else {
            let cell = tableViewX.dequeueReusableCell(withIdentifier: "BallingCell", for: indexPath) as! BallingCell
            cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            if indexPath.row == 0 {
                cell.bgView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.5764705882, blue: 0.2784313725, alpha: 1)
            }
            cell.bawlerName.text = tableArray?.bowlingStat[indexPath.row].playerName
            cell.Over.text = tableArray?.bowlingStat[indexPath.row].overs
            cell.maiden.text = tableArray?.bowlingStat[indexPath.row].medians
            cell.run.text = tableArray?.bowlingStat[indexPath.row].run
            cell.wicket.text = tableArray?.bowlingStat[indexPath.row].wicket
            cell.sR.text = tableArray?.bowlingStat[indexPath.row].ecRate

            cell.bgView.layer.cornerRadius = 10
            cell.bgView.layer.masksToBounds = false
            cell.bgView.layer.shadowColor = UIColor.black.cgColor
            cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.bgView.layer.shadowOpacity = 0.2
            cell.bgView.layer.shadowRadius = 3
            return cell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewX.deselectRow(at: indexPath, animated: true)

        guard NetworkManagerST.shared.isConnectedToNetwork() && indexPath.section != 2 else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingPlayerInfoVC") as? LZPagingPlayerInfoVC {
            guard NetworkManagerST.shared.isConnectedToNetwork() else {
                showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
                return
            }
            if indexPath.section == 0 {
                if tableArray?.battingStat[indexPath.row].playerID == 0 { return }
                destinationVC.playerID = tableArray?.battingStat[indexPath.row].playerID
            } else {
                if tableArray?.bowlingStat[indexPath.row].playerID == 0 { return }
                destinationVC.playerID = tableArray?.bowlingStat[indexPath.row].playerID
            }
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
