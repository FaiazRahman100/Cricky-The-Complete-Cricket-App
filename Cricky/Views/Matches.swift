//
//  Matches.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import UIKit

class Matches: UIViewController {
    @IBOutlet var loadingView: UIView!
    @IBOutlet var segmentControl: UISegmentedControl!

    @IBOutlet var tableViewX: UITableView!

    @IBOutlet var tableViewBgImage: UIImageView!

    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var internetStatus: UILabel!

    var viewModel = MatchesViewModel()
    var tableArray = [MatchTiles]()
    var passedLink: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewX.delegate = self
        tableViewX.dataSource = self
        setupBinders()

        let selectedAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        let normalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)

        if let value = passedLink {
            viewModel.downloadFixture(link: value)
            // segementControl.isHidden = true
        } else {
            let link = AllMatchesLinkBuilder(token: Constant.Key)
                .setStartsBetween(startsBetween: getMonthDatesInterval(monthInterval: 3))
                .setSort(sort: "-starting_at")
                .setInclude(include: "stage,localteam,visitorteam,tosswon,runs.team")
                .build()
            viewModel.downloadFixture(link: link)
        }
    }

    func setupBinders() {
        viewModel.tableData.bind(listener: { [weak self] tableData in
            self?.tableArray = tableData!

            if tableData?.count == 0 {
                self?.tableViewBgImage.isHidden = false
                self?.tableViewBgImage.image = UIImage(named: "NoResult")
                self?.tableViewBgImage.alpha = 0
                UIView.animate(withDuration: 1, animations: {
                    self?.tableViewBgImage.alpha = 1
                })
            }

            DispatchQueue.main.async { [weak self] in
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

    @IBAction func segmentControllerValueChanged(_ sender: UISegmentedControl) {
        tableViewBgImage.isHidden = true
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.allMatchesSelected()
        case 1:
            viewModel.recentMatchedSelected()
        case 2:
            viewModel.upcomingMatchSelected()
        case 3:
            viewModel.liveMatchSelected()
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
