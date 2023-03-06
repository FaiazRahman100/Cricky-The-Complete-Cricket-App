//
//  PlayerCareerVCExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import Foundation
import UIKit

extension PlayerCareerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "careerStatCell", for: indexPath) as! careerStatCell
//        cell.field.textColor = .black
//        cell.domestic.textColor = .black
//        cell.t20I.textColor = .black
//        cell.odi.textColor = .black
        if indexPath.row == 0 {
            cell.bgView.backgroundColor = #colorLiteral(red: 0.5341193676, green: 0.7582287192, blue: 0.8341502547, alpha: 1)
//            cell.field.textColor = .white
//            cell.domestic.textColor = .white
//            cell.t20I.textColor = .white
//            cell.odi.textColor = .white
//
        }

        cell.field.text = tableArray[indexPath.row].name
        cell.domestic.text = tableArray[indexPath.row].t20
        cell.t20I.text = tableArray[indexPath.row].t20I
        cell.odi.text = tableArray[indexPath.row].odi
        cell.bgView.layer.cornerRadius = 10

        cell.bgView.layer.masksToBounds = false
        cell.bgView.layer.shadowColor = UIColor.black.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.bgView.layer.shadowOpacity = 0.1
        cell.bgView.layer.shadowRadius = 3

        return cell
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}
