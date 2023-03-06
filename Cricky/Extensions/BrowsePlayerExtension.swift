//
//  BrowsePlayerExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import Foundation
import UIKit

// MARK: Searchbar Methods

extension BrowsePlayerVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_: UITextField) {
        suggestionConstraint.constant = 0
        let searchText = (searchTextField.text!)
        if searchText.count == 0 {
            tableArray = PreSavedDataSt.shared.suggestedPlayers
            suggestionConstraint.constant = 50
        }
        if searchText.count > 2 {
            searchThisQuery(searchText)
        }
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_: UITextField) {
        let query = searchTextField.text!
        searchThisQuery(query)
        searchTextField.text = ""
    }
}

extension BrowsePlayerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "browsePlayerCell", for: indexPath) as! browsePlayerCell
        cell.countryImg.layer.cornerRadius = cell.countryImg.frame.width / 2
        cell.playerName.text = tableArray[indexPath.row].name
        cell.countryName.text = tableArray[indexPath.row].country

        let url1 = URL(string: tableArray[indexPath.row].playerImg)
        cell.playerImage.sd_setImage(with: url1!, placeholderImage: UIImage(named: "placeholder"))

        let url2 = URL(string: tableArray[indexPath.row].countryImg)
        cell.countryImg.sd_setImage(with: url2!, placeholderImage: UIImage(named: "placeholder"))

        cell.bgView.layer.cornerRadius = 10

        cell.bgView.layer.masksToBounds = false
        cell.bgView.layer.shadowColor = UIColor.black.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.bgView.layer.shadowOpacity = 0.2
        cell.bgView.layer.shadowRadius = 3
        cell.playerImage.layer.cornerRadius = cell.playerImage.frame.width / 2
        cell.countryName.text = tableArray[indexPath.row].country

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewX.deselectRow(at: indexPath, animated: true)

        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "LZPagingPlayerInfoVC") as? LZPagingPlayerInfoVC {
            destinationVC.playerID = tableArray[indexPath.row].id
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
