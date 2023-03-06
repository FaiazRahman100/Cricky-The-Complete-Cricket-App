//
//  Series.swift
//  Cricky
//
//  Created by Faiaz Rahman on 19/2/23.
//

import UIKit

class Series: UIViewController {
    @IBOutlet var indicator: UIActivityIndicatorView!

    @IBOutlet var loadingView: UIView!
    @IBOutlet var tableViewX: UITableView!
    var viewModel = SeriesViewModel()
    var tableArray = [SeriesInfo]()
    var leagueList: [LeagueInfo] = []

    @IBOutlet var internetStatus: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewX.delegate = self
        tableViewX.dataSource = self
        let league1 = LeagueInfo(leagueID: 5, seasonID: 1079, leagueName: "Big Bash League", leagueImage: "https://cdn.sportmonks.com/images/cricket/leagues/5/5.png")
        let league2 = LeagueInfo(leagueID: 10, seasonID: 1145, leagueName: "CSA T20 Challenge", leagueImage: "https://cdn.sportmonks.com/images/cricket/leagues/10/10.png")
        leagueList = [league1, league2]
        setupBinders()
        viewModel.downloadSeries()

        // Do any additional setup after loading the view.
    }

    func setupBinders() {
        viewModel.seriesList.bind(listener: { [weak self] seriesList in
            self?.tableArray = seriesList!
            //  dump(self?.tableArray)
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
