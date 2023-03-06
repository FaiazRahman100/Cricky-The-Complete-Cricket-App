//
//  ScoreboardVC.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import UIKit

class ScoreboardVC: UIViewController {
    @IBOutlet var SegmentControl: UISegmentedControl!

    @IBOutlet var tableViewX: UITableView!
    @IBOutlet var teamName: UILabel!

    @IBOutlet var topview: UIView!
    @IBOutlet var scoreLabel: UILabel!
    var viewModel = ScoreboardViewModel()
    var tableArray: sbSeason?
//    var essentialData

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewX.dataSource = self
        tableViewX.delegate = self

        let TableNib1 = UINib(nibName: "BattingCell", bundle: nil)
        tableViewX.register(TableNib1, forCellReuseIdentifier: "BattingCell")

        let TableNib2 = UINib(nibName: "BallingCell", bundle: nil)
        tableViewX.register(TableNib2, forCellReuseIdentifier: "BallingCell")
        topview.layer.cornerRadius = 10
        setupBinders()
    }

    func setupBinders() {
        viewModel.selectedSeason.bind(listener: { [weak self] currentSeason in
            self?.tableArray = currentSeason!
            // dump(currentSeason)
            self?.teamName.text = currentSeason?.seasonName
            self?.scoreLabel.text = currentSeason?.seasonScore
            DispatchQueue.main.async { [weak self] in
                self?.tableViewX.reloadData()
            }
        })
    }

    @IBAction func segmenControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.s1Selected()
        case 1:
            viewModel.s2selected()
        default:
            break
        }
    }
}
