//
//  Home.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import UIKit

class Home: UIViewController {
    @IBOutlet var collectionViewX: UICollectionView!

    @IBOutlet var topConstrain: NSLayoutConstraint!

    @IBOutlet var loadingView: UIView!

    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var intenetStatusLabel: UILabel!

    @IBOutlet var tableViewX: UITableView!
    var viewModel = HomeViewModel()
    var tableArray = [MatchTiles]()
    var previousGames = [MatchTiles]()

    var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewX.delegate = self
        collectionViewX.dataSource = self
        tableViewX.delegate = self
        tableViewX.dataSource = self

        let cvNib = UINib(nibName: "HomeCvCell", bundle: nil)
        collectionViewX.register(cvNib, forCellWithReuseIdentifier: "HomeCvCell")

        let tableNib1 = UINib(nibName: "PreviousGames", bundle: nil)
        tableViewX.register(tableNib1, forCellReuseIdentifier: "PreviousGames")

        let tableNib2 = UINib(nibName: "GameCell", bundle: nil)
        tableViewX.register(tableNib2, forCellReuseIdentifier: "GameCell")

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 410, height: 170)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        collectionViewX.collectionViewLayout = layout

        setupBinders()

        viewModel.applicationStarted()
    }

    func setupBinders() {
        viewModel.fixtureList.bind(listener: { [weak self] fixtureList in
            self?.tableArray = fixtureList!

            DispatchQueue.main.async { [weak self] in
                self?.collectionViewX.reloadData()
                // self?.tableViewX.reloadData()
            }

        })
        viewModel.finishedGames.bind(listener: { [weak self] finishedGames in
            self?.previousGames = finishedGames!

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
                self?.intenetStatusLabel.text = "No Internet Connetion."
                self?.triggerAlert()
            }
        })
    }

    func triggerAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Play Game", style: .default, handler: { _ in
            if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "Game") as? Game {
                print("game Clicked")
                destinationVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Exit App", style: .default, handler: { _ in
            exit(0) // Terminate the app
        }))

        present(alert, animated: true, completion: nil)
    }
}
