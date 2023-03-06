//
//  SeriesExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 19/2/23.
//

import Foundation
import UIKit

extension Series: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 30 // Set the height of the header to 100 points
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .clear
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 40, height: 30))
        if section == 0 {
            headerLabel.text = "Trending Tournaments"
        } else {
            headerLabel.text = "Series"
        }
        headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        headerLabel.textColor = #colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)
        headerView.addSubview(headerLabel)

        return headerView
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return leagueList.count
        } else {
            return tableArray.count
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath) as! SeriesCell
        cell.bgView.layer.cornerRadius = 10

        cell.bgView.layer.masksToBounds = false
        cell.bgView.layer.shadowColor = UIColor.black.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.bgView.layer.shadowOpacity = 0.2
        cell.bgView.layer.shadowRadius = 3

        if indexPath.section == 0 {
            cell.seriesName.text = leagueList[indexPath.row].leagueName
            let url = URL(string: leagueList[indexPath.row].leagueImage)
            cell.seriesImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))

            return cell

        } else {
            cell.seriesName.text = tableArray[indexPath.row].name
            // cell.seriesImage.image = UIImage(named: "plane")
            return cell
        }
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if indexPath.section == 0 {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingLeagueInfo") as? LZPagingLeagueInfo {
                let link2 = "https://cricket.sportmonks.com/api/v2.0/fixtures?api_token=8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR&sort=-starting_at&filter[league_id]=\(leagueList[indexPath.row].leagueID)&filter[season_id]=\(leagueList[indexPath.row].seasonID)&&include=stage,localteam,visitorteam,tosswon,runs.team"
//
//                destinationVC.passedLink = link

                let essentialData = (link2, leagueList[indexPath.row].seasonID)
                dump(essentialData)

                destinationVC.essentialData = essentialData
//                destinationVC.passedSeasonId = (leagueList[indexPath.row].seasonID)
//                destinationVC.viewModel.requestApi(seasonID: (leagueList[indexPath.row].seasonID)) //(leagueList[indexPath.row].seasonID)
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }

        if indexPath.section == 1 {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Matches") as? Matches {
                let link = "https://cricket.sportmonks.com/api/v2.0/fixtures?api_token=8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR&sort=-starting_at&filter[stage_id]=\(tableArray[indexPath.row].stageID)s&filter[league_id]=\(tableArray[indexPath.row].leagueID)&filter[season_id]=\(tableArray[indexPath.row].seasonID)&include=stage,localteam,visitorteam,tosswon,runs.team"

                destinationVC.passedLink = link
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
}
