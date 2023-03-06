//
//  DatewiseFixtureVC.swift
//  Cricky
//
//  Created by bjit on 24/2/23.
//

import UIKit

class DatewiseFixtureVC: UIViewController {
    @IBOutlet var startingDate: UIDatePicker!

    @IBOutlet var endDate: UIDatePicker!

    @IBOutlet var searchBtn: UIButton!

    var startDate = ""
    var endingDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBtn.layer.cornerRadius = 5

        startingDate.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        endDate.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
    }

    @IBAction func searchBtnClicked(_: Any) {
        guard NetworkManagerST.shared.isConnectedToNetwork() else {
            showToast(message: "Check Internet Connection", font: .systemFont(ofSize: 12))
            return
        }

        if startDate.count == 0 && endingDate.count == 0 {
            return
        }
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Matches") as? Matches {
            let link = "https://cricket.sportmonks.com/api/v2.0/fixtures?api_token=8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR&filter[starts_between]=\(startDate),\(endingDate)&sort=-starting_at&include=stage,localteam,visitorteam,tosswon,runs.team"

            destinationVC.passedLink = link
            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    @objc func startDateChanged(_ sender: UIDatePicker) {
        // Handle the value changed event
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        var selectedDate = dateFormatter.string(from: sender.date)
        selectedDate = dateConverter(newDate: selectedDate)
        startDate = selectedDate
        print("Selected date: \(selectedDate)")
    }

    @objc func endDateChanged(_ sender: UIDatePicker) {
        // Handle the value changed event
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        var selectedDate = dateFormatter.string(from: sender.date)
        selectedDate = dateConverter(newDate: selectedDate)
        print("Selected date: \(selectedDate)")
        endingDate = selectedDate
    }

    func dateConverter(newDate: String) -> String {
        let inputDateString = newDate
        let inputDateFormatter = DateFormatter()
        var outputDate = ""
        inputDateFormatter.dateFormat = "MMM dd, yyyy 'at' h:mm:ss a"
        if let inputDate = inputDateFormatter.date(from: inputDateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd"
            outputDate = outputDateFormatter.string(from: inputDate)
            print(outputDate) // Output: 2023-03-24
        }

        return outputDate
    }
}
