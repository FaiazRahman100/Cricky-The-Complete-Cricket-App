//
//  MatchesExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import Foundation
import Network
import SDWebImage
import UIKit

extension Matches: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "MatchesCell", for: indexPath) as! MatchesCell

        let inputString = tableArray[i].note

        if inputString.contains("balls remaining") {
            let pattern = "\\s*\\(.*\\)$" // matches the last parentheses and its contents
            let regex = try! NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: inputString.count)
            let outputString = regex.stringByReplacingMatches(in: inputString, options: [], range: range, withTemplate: "")
            cell.resultLabel.text = outputString
        } else {
            cell.resultLabel.text = inputString
        }

        cell.stageLabel.text = tableArray[i].stage

        let round = tableArray[i].round
        cell.dateLabel.text = "\(tableArray[i].time) - \(round)"

        if tableArray[i].status == "Finished" {
            cell.StatusLabel.text = tableArray[i].status
            cell.statusView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.5764705882, blue: 0.2784313725, alpha: 1)
        } else if tableArray[i].status == "NS" {
            cell.StatusLabel.text = "Upcoming"
            cell.statusView.backgroundColor = #colorLiteral(red: 0.8644711375, green: 0.4183590412, blue: 0.0813376829, alpha: 1)
            cell.resultLabel.text = tableArray[i].round
            cell.dateLabel.text = "\(tableArray[i].time)"
        } else if tableArray[i].status == "Aban." {
            cell.StatusLabel.text = "Abandoned"
            cell.statusView.backgroundColor = #colorLiteral(red: 0.3110105991, green: 0.1981342137, blue: 0.5179204941, alpha: 1)
        } else {
            cell.StatusLabel.text = "Live"
            cell.statusView.backgroundColor = #colorLiteral(red: 0.8947126269, green: 0, blue: 0.07631716877, alpha: 1)
        }

        cell.team1Code.text = tableArray[i].team1Name
        cell.team2Code.text = tableArray[i].team2Name

        cell.team1Score.text = "\(tableArray[i].team1Score)"
        cell.team2Score.text = "\(tableArray[i].team2Score)"

        cell.team1Over.text = (tableArray[i].team1Over)
        cell.team2Over.text = (tableArray[i].team2Over)

        let url1 = URL(string: tableArray[i].team1Img)
        cell.team1Img.sd_setImage(with: url1, placeholderImage: UIImage(named: "placeholder"))

        let url2 = URL(string: tableArray[i].team2Img)
        cell.team2Img.sd_setImage(with: url2, placeholderImage: UIImage(named: "placeholder"))

        cell.bgView.layer.cornerRadius = 10

        cell.bgView.layer.masksToBounds = false
        cell.bgView.layer.shadowColor = UIColor.black.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.bgView.layer.shadowOpacity = 0.2
        cell.bgView.layer.shadowRadius = 3

        cell.statusView.layer.cornerRadius = 4
        cell.team1Img.layer.cornerRadius = 3 // cell.team1Img.frame.size.width / 2
        cell.team2Img.layer.cornerRadius = 3 // cell.team2Img.frame.size.width / 2

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewX.deselectRow(at: indexPath, animated: true)

        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if tableArray[indexPath.row].status != "NS" {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingMatchInfoVC") as? LZPagingMatchInfoVC {
                // destinationVC.viewModel.downloadFixture(fixtureID: tableArray[indexPath.row].fixtureID)
                destinationVC.fixtureID = tableArray[indexPath.row].fixtureID
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        } else {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "UpcomingMatch") as? UpcomingMatch {
                // destinationVC.viewModel.downloadFixture(fixtureID: tableArray[indexPath.row].fixtureID)
                destinationVC.viewModel.passedGame = tableArray[indexPath.row]
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }

//
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }

//
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let index = tableViewX.indexPathForSelectedRow
//
//        if let destinationVC = segue.destination as? MatchInfo{
//            destinationVC.fixtureID = tableArray[index!.row].fixtureID
//        }
//    }
}
