//
//  SquadVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 20/2/23.
//

import UIKit

class SquadVC: UIViewController {
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var tableViewX: UITableView!

    var viewModel = SquadViewModel()
    var passedArray: [TeamX]?

    var tableArray = [PlayerIdentity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewX.delegate = self
        tableViewX.dataSource = self

        let tableNib = UINib(nibName: "PlayerListCell", bundle: nil)
        tableViewX.register(tableNib, forCellReuseIdentifier: "PlayerListCell")

        let selectedAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2078382969, green: 0.2078469396, blue: 0.3469981551, alpha: 1)]
        let normalAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]

        segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)

        setupBinders()
    }

    func setupBinders() {
        viewModel.teamList.bind(listener: { [self] teamList in
            passedArray = teamList
            tableArray = teamList![0].playerList
            segmentControl.setTitle(teamList![0].teamName, forSegmentAt: 0)
            segmentControl.setTitle(teamList![1].teamName, forSegmentAt: 1)
            DispatchQueue.main.async { [weak self] in
                self?.tableViewX.reloadData()
            }

        })
    }

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableArray = passedArray![0].playerList
        case 1:
            tableArray = passedArray![1].playerList

        default:
            break
        }
        DispatchQueue.main.async {
            self.tableViewX.reloadData()
        }
    }
}
