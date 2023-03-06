//
//  LeagueStandingVC.swift
//  Cricky
//
//  Created by bjit on 23/2/23.
//

import UIKit

class LeagueStandingVC: UIViewController {
    @IBOutlet var tableViewX: UITableView!
    var tableArray: [RankRow] = []
    var viewModel = LeagueStandingViewModel()

    @IBOutlet var loadingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewX.dataSource = self
        tableViewX.delegate = self
        let TableNib1 = UINib(nibName: "RankingCell", bundle: nil)
        tableViewX.register(TableNib1, forCellReuseIdentifier: "RankingCell")
        setupBinders()
    }

    func setupBinders() {
        viewModel.tableArray.bind(listener: { [weak self] leagueStandingList in
            self?.tableArray = leagueStandingList!
            DispatchQueue.main.async { [weak self] in
                self?.tableViewX.reloadData()
            }
        })
        viewModel.loadingComplete.bind(listener: { [weak self] _ in

            UIView.animate(withDuration: 1, animations: {
                self?.loadingView.alpha = 0
            }) { finished in
                if finished {
                    self?.loadingView.isHidden = true
                }
            }
        })
    }
}
