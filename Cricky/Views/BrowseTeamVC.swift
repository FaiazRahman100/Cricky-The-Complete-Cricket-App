//
//  BrowseTeamVC.swift
//  Cricky
//
//  Created by Faiaz Rahman on 25/2/23.
//

import CoreData
import UIKit

struct TeamTiles {
    let id: Int
    let name, image: String
}

class BrowseTeamVC: UIViewController {
    @IBOutlet var suggestionViewConstraint: NSLayoutConstraint!

    var tableArray: [TeamTiles] = PreSavedDataSt.shared.suggestedTeam {
        didSet {
            DispatchQueue.main.async {
                self.tableViewX.reloadData()
            }
        }
    }

    @IBOutlet var tableViewX: UITableView!

    @IBOutlet var searchTextField: UITextField! {
        didSet {
            // searchTextB.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            let whitePlaceholderText = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2610501945, green: 0.2790973186, blue: 0.2911033034, alpha: 1)])

            searchTextField.attributedPlaceholder = whitePlaceholderText
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        tableViewX.delegate = self
        tableViewX.dataSource = self

        let nib = UINib(nibName: "BrowseTeamCell", bundle: nil)
        tableViewX.register(nib, forCellReuseIdentifier: "BrowseTeamCell")
        // Do any additional setup after loading the view.
    }

    func searchThisQuery(_ query: String) {
        if query.count == 0 {
            showToast(message: "Please input you query", font: .systemFont(ofSize: 12.0))
            return
        }

        print(query)

        let predicateX = NSPredicate(format: "name CONTAINS[c] %@", query)

        let request: NSFetchRequest<TeamCard> = TeamCard.fetchRequest()

        request.predicate = predicateX

        var matchedArray = [TeamCard]()

        do {
            matchedArray = try CoreDataManager.shared.context.fetch(request)

        } catch {
            print("Error\(error)")
        }

        if matchedArray.count == 0 {
            showToast(message: "No Team Found", font: .systemFont(ofSize: 12.0))
            return
        } else {
            var foundData: [TeamTiles] = []
            for i in 0 ..< matchedArray.count {
                let name = matchedArray[i].name!
                let id = matchedArray[i].id
                let img = matchedArray[i].image!

                let temp = TeamTiles(id: Int(id), name: name, image: img)
                foundData.append(temp)
            }

            tableArray = foundData
        }
    }
}
