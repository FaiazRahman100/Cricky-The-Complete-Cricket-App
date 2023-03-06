//
//  HomeExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import Foundation
import SDWebImage
import UIKit

extension Home: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        tableArray.count
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewX.dequeueReusableCell(withReuseIdentifier: "HomeCvCell", for: indexPath) as! HomeCvCell

        let i = indexPath.row

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

        cell.middleView.text = ""
        cell.venueMiddle.text = ""
//
        cell.arrowImage.isHidden = false
        if tableArray[i].status == "Finished" {
            cell.StatusLabel.text = tableArray[i].status
            cell.statusView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.5764705882, blue: 0.2784313725, alpha: 1)
            cell.middleView.text = ""
            cell.venueMiddle.text = ""
        } else if tableArray[i].status == "NS" {
            cell.stageLabel.text = tableArray[i].round
            cell.StatusLabel.text = "Upcoming"
            cell.statusView.backgroundColor = #colorLiteral(red: 0.8644711375, green: 0.4183590412, blue: 0.0813376829, alpha: 1)
            cell.resultLabel.text = "\(tableArray[i].venue), \(tableArray[i].venueCity)"
            cell.dateLabel.text = tableArray[i].time
            cell.middleView.text = tableArray[i].stage
            cell.venueMiddle.text = "\(tableArray[i].venue), \(tableArray[i].venueCity)"

            let dateString = tableArray[i].date

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            guard let date = dateFormatter.date(from: dateString) else {
                fatalError("Invalid date string")
            }

            _ = UILabel()

            func updateTimeLeftLabel() {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute] // , .second]
                formatter.unitsStyle = .full
                formatter.zeroFormattingBehavior = .dropAll

                let timeLeftString = formatter.string(from: Date(), to: date)!
                cell.resultLabel.text = "\(timeLeftString) Left"
            }

            updateTimeLeftLabel() // Update the label once initially

            cell.arrowImage.isHidden = true
        } else if tableArray[i].status == "Aban." {
            cell.StatusLabel.text = "Abandoned"
            cell.statusView.backgroundColor = #colorLiteral(red: 0.3110105991, green: 0.1981342137, blue: 0.5179204941, alpha: 1)
            cell.middleView.text = ""
        } else {
            cell.StatusLabel.text = tableArray[i].status
            cell.statusView.backgroundColor = #colorLiteral(red: 0.8947126269, green: 0, blue: 0.07631716877, alpha: 1)
            cell.middleView.text = ""
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
        cell.bgView.layer.shadowOpacity = 0.5
        cell.bgView.layer.shadowRadius = 3

        cell.statusView.layer.cornerRadius = 4
        cell.team1Img.layer.cornerRadius = 3 // cell.team1Img.frame.size.width / 2
        cell.team2Img.layer.cornerRadius = 3 // cell.team2Img.frame.size.width / 2

        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
}

extension Home: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            UIView.animate(withDuration: 0.4, animations: { [self] in
                collectionViewX.alpha = 1
                self.topConstrain.constant = 200
                //  self.tabBarController?.tabBar.isHidden = false
                self.view.layoutIfNeeded()
            }) { _ in

                self.collectionViewX.isHidden = false
            }

        } else if scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.4, animations: { [self] in
                collectionViewX.alpha = 0
                self.topConstrain.constant = 0
                // self.tabBarController?.tabBar.isHidden = true
                self.view.layoutIfNeeded()
            }) { _ in
                self.collectionViewX.isHidden = true
            }
        }
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 30 // Set the height of the header to 100 points
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .clear
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 30, height: 20))
        if section == 0 {
            headerLabel.text = "Trending Tournaments"
        } else if section == 1 {
            headerLabel.text = "Recent Matches"
        } else {
            headerLabel.text = "Play Cricket Mania"
        }
        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerLabel.textColor = #colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 0.7636330712)
        headerView.addSubview(headerLabel)

        return headerView
    }

    func numberOfSections(in _: UITableView) -> Int {
        3
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let leagueList = PreSavedDataSt.shared.leagueList

        if section == 0 {
            return leagueList.count // }
        } else if section == 1 {
            return previousGames.count
        } else {
            return 1
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leagueList = PreSavedDataSt.shared.leagueList
        if indexPath.section == 0 {
            let cell = tableViewX.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
            cell.leagueName.text = leagueList[indexPath.row].leagueName
            let url = URL(string: leagueList[indexPath.row].leagueImage)
            cell.LeagueImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.layer.masksToBounds = false
            cell.bgView.layer.shadowColor = UIColor.black.cgColor
            cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.bgView.layer.shadowOpacity = 0.5
            cell.bgView.layer.shadowRadius = 3
            return cell
        } else if indexPath.section == 1 {
            let i = indexPath.row
            let cell = tableViewX.dequeueReusableCell(withIdentifier: "PreviousGames", for: indexPath) as! PreviousGames
            let inputString = previousGames[i].note

            if inputString.contains("balls remaining") {
                let pattern = "\\s*\\(.*\\)$" // matches the last parentheses and its contents
                let regex = try! NSRegularExpression(pattern: pattern)
                let range = NSRange(location: 0, length: inputString.count)
                let outputString = regex.stringByReplacingMatches(in: inputString, options: [], range: range, withTemplate: "")
                cell.resultLabel.text = outputString
            } else {
                cell.resultLabel.text = inputString
            }
            cell.stageLabel.text = previousGames[i].stage

            let round = previousGames[i].round
            cell.dateLabel.text = "\(previousGames[i].time) - \(round)"

            if previousGames[i].status == "Finished" {
                cell.StatusLabel.text = previousGames[i].status
                cell.statusView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.5764705882, blue: 0.2784313725, alpha: 1)
            } else if previousGames[i].status == "NS" {
                cell.StatusLabel.text = "Upcoming"
                cell.statusView.backgroundColor = #colorLiteral(red: 0.8644711375, green: 0.4183590412, blue: 0.0813376829, alpha: 1)
                cell.resultLabel.text = previousGames[i].round
                cell.dateLabel.text = "\(previousGames[i].time)"

            } else if previousGames[i].status == "Aban." {
                cell.StatusLabel.text = "Abandoned"
                cell.statusView.backgroundColor = #colorLiteral(red: 0.3110105991, green: 0.1981342137, blue: 0.5179204941, alpha: 1)
            } else {
                cell.StatusLabel.text = "Live"
                cell.statusView.backgroundColor = #colorLiteral(red: 0.8947126269, green: 0, blue: 0.07631716877, alpha: 1)
            }

            cell.team1Code.text = previousGames[i].team1Name
            cell.team2Code.text = previousGames[i].team2Name

            cell.team1Score.text = "\(previousGames[i].team1Score)"
            cell.team2Score.text = "\(previousGames[i].team2Score)"

            cell.team1Over.text = (previousGames[i].team1Over)
            cell.team2Over.text = (previousGames[i].team2Over)

            let url1 = URL(string: previousGames[i].team1Img)
            cell.team1Img.sd_setImage(with: url1, placeholderImage: UIImage(named: "placeholder"))

            let url2 = URL(string: previousGames[i].team2Img)
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
        } else {
            let cell = tableViewX.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell

            cell.bgView.layer.cornerRadius = 10

            cell.bgView.layer.masksToBounds = true
            cell.bgView.layer.shadowColor = UIColor.black.cgColor
            cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.bgView.layer.shadowOpacity = 0.2
            cell.bgView.layer.shadowRadius = 3

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 2 {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Game") as? Game {
                print("game Clicked")
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }

        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if indexPath.section == 0 {
            let leagueList = PreSavedDataSt.shared.leagueList
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingLeagueInfo") as? LZPagingLeagueInfo {
                let link2 = "https://cricket.sportmonks.com/api/v2.0/fixtures?api_token=8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR&sort=-starting_at&filter[league_id]=\(leagueList[indexPath.row].leagueID)&filter[season_id]=\(leagueList[indexPath.row].seasonID)&&include=stage,localteam,visitorteam,tosswon,runs.team"
                let essentialData = (link2, leagueList[indexPath.row].seasonID)
                dump(essentialData)

                destinationVC.essentialData = essentialData
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }

        } else if indexPath.section == 1 {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingMatchInfoVC") as? LZPagingMatchInfoVC {
                destinationVC.fixtureID = previousGames[indexPath.row].fixtureID
                destinationVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}
