//
//  PlayerCareerVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import UIKit

class PlayerCareerVC: UIViewController {
    @IBOutlet var tableViewX: UITableView!
    var viewModel = PlayerCareerViewModel()
    var tableArray = [rowWiseRecord]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewX.delegate = self
        tableViewX.dataSource = self
        let tableNib1 = UINib(nibName: "careerStatCell", bundle: nil)
        tableViewX.register(tableNib1, forCellReuseIdentifier: "careerStatCell")
        setupBinders()
        // Do any additional setup after loading the view.
    }

    func setupBinders() {
        viewModel.careerStats.bind(listener: { [self] careerDataX in
            tableArray = careerDataX!
            dump(careerDataX)
            DispatchQueue.main.async { [self] in
                tableViewX.reloadData()
            }
        })
    }
}
