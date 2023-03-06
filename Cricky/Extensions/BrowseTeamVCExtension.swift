//
//  BrowseTeamVCExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import Foundation
import UIKit

// MARK: Searchbar Methods

extension BrowseTeamVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_: UITextField) {
        suggestionViewConstraint.constant = 0
        let searchText = (searchTextField.text!)
        if searchText.count == 0 {
            tableArray = PreSavedDataSt.shared.suggestedTeam
            suggestionViewConstraint.constant = 50
        }
        searchThisQuery(searchText)
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

extension BrowseTeamVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "BrowseTeamCell", for: indexPath) as! BrowseTeamCell
        cell.teamImg.layer.cornerRadius = cell.teamImg.frame.width / 2
        cell.teamName.text = tableArray[indexPath.row].name

        let url1 = URL(string: tableArray[indexPath.row].image)
        cell.teamImg.sd_setImage(with: url1!, placeholderImage: UIImage(named: "placeholder"))
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.layer.masksToBounds = false
        cell.bgView.layer.shadowColor = UIColor.black.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.bgView.layer.shadowOpacity = 0.2
        cell.bgView.layer.shadowRadius = 3

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

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}
