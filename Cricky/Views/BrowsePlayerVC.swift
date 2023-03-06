//
//  BrowsePlayerVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 24/2/23.
//

import CoreData
import SDWebImage
import UIKit

class BrowsePlayerVC: UIViewController {
    @IBOutlet var suggestionConstraint: NSLayoutConstraint!
    @IBOutlet var tableViewX: UITableView!
    @IBOutlet var searchTextField: UITextField! {
        didSet {
            let whitePlaceholderText = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2610501945, green: 0.2790973186, blue: 0.2911033034, alpha: 1)])
            searchTextField.attributedPlaceholder = whitePlaceholderText
        }
    }

    var tableArray: [PlayerMiniInfo] = PreSavedDataSt.shared.suggestedPlayers {
        didSet {
            DispatchQueue.main.async {
                self.tableViewX.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        tableViewX.delegate = self
        tableViewX.dataSource = self

        let TableNib1 = UINib(nibName: "browsePlayerCell", bundle: nil)
        tableViewX.register(TableNib1, forCellReuseIdentifier: "browsePlayerCell")
        // Do any additional setup after loading the view.
    }

    @IBAction func searchBtnClicked(_: Any) {
        let query = searchTextField.text!
        searchThisQuery(query)
        searchTextField.text = ""
    }

    func searchThisQuery(_ query: String) {
        if query.count == 0 {
            showToast(message: "Please input you query", font: .systemFont(ofSize: 12.0))
            return
        }
        let predicateX = NSPredicate(format: "name CONTAINS[c] %@ || country CONTAINS[c] %@", query, query)

        let request: NSFetchRequest<PlayerCard> = PlayerCard.fetchRequest()

        request.predicate = predicateX

        var matchedArray = [PlayerCard]()

        do {
            matchedArray = try CoreDataManager.shared.context.fetch(request)

        } catch {
            print("Error\(error)")
        }

        if matchedArray.count == 0 {
            showToast(message: "No Player Found", font: .systemFont(ofSize: 12.0))
            tableArray = []
            return
        } else {
            var foundData: [PlayerMiniInfo] = []
            for i in 0 ..< matchedArray.count {
                let name = matchedArray[i].name
                let id = matchedArray[i].id
                let img = matchedArray[i].image
                let country = matchedArray[i].country
                let countryImg = matchedArray[i].countryImg

                let temp = PlayerMiniInfo(id: Int(id), name: name!, playerImg: img!, country: country!, countryImg: countryImg!)
                foundData.append(temp)
            }

            tableArray = foundData
        }
    }
}
