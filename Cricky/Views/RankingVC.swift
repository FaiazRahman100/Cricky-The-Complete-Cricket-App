//
//  RankingVC.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import UIKit

class RankingVC: UIViewController {
    //    var loaderArray : [MatchType] = []
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var loadingView: UIView!

    @IBOutlet var internetStatus: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!

    var tableArray: [RankRow] = []
    var viewModel = RankingViewModel()
    @IBOutlet var tableViewX: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewX.dataSource = self
        tableViewX.delegate = self

        let TableNib1 = UINib(nibName: "RankingCell", bundle: nil)
        tableViewX.register(TableNib1, forCellReuseIdentifier: "RankingCell")

        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let normalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)

        viewModel.requestApi()
        setupBinders()

        // Do any additional setup after loading the view.
    }

    func setupBinders() {
        viewModel.tableArray.bind(listener: { [weak self] rankingList in
            self?.tableArray = rankingList!
            dump(rankingList)

            DispatchQueue.main.async { [weak self] in
                // self?.collectionViewX.reloadData()
                self?.tableViewX.reloadData()
            }
        })
        viewModel.loadingComplete.bind(listener: { [weak self] status in

            if status! {
                UIView.animate(withDuration: 1, animations: {
                    self?.loadingView.alpha = 0
                }) { finished in
                    if finished {
                        self?.loadingView.isHidden = true
                    }
                }
            } else {
                self?.indicator.stopAnimating()
                self?.internetStatus.text = "No Internet Connetion."
                self?.triggerAlert()
            }
        })
    }

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.t20Selected()
        case 1:
            viewModel.odiSelected()
        case 2:
            viewModel.testSelected()
        default:
            break
        }
    }

    func triggerAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { _ in
            exit(0) // Terminate the app
        }))
        alert.addAction(UIAlertAction(title: "Play Game", style: .default, handler: { _ in
            if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "Game") as? Game {
                print("game Clicked")
                destinationVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }))

        present(alert, animated: true, completion: nil)
    }
}
