//
//  CoreDataManager.swift
//  Cricky
//
//  Created by Faiaz Rahman on 23/2/23.
//

import CoreData
import Foundation
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var receiveData: [PlayerDetail]?
    var playerList = [PlayerMiniInfo]()
    var allTeamsData: [TeamsData]?
    var dbLoader = [PlayerCard]()
    var dbLoaderTeams = [TeamCard]()

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error")
        }
    }

    func downloadAllPlayer() {
        let link = "https://cricket.sportmonks.com/api/v2.0/players/?api_token=8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR&fields[players]=fullname,image_path&include=country&fields[countries]=name"
        guard let url = URL(string: link) else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [weak self] (result: Result<PlayerAll, Error>) in
            switch result {
            case let .success(response):
                self?.receiveData = response.data

                print("Download Complete")
                self?.process()

                //  self?.fixtureList.value = self?.matchList

                debugPrint("We got a successful result with \(response.data.count) users.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
    }

    func downloadAllTeam() {
        guard let url = URL(string: "https://cricket.sportmonks.com/api/v2.0/teams?api_token=8K4NjBE18zBFNZF1DzGSSFp5kdggtnyI3FqvD1rbBhEogkUsVNPMsgDuaMxR") else { fatalError("Invalid URL") }

        NetworkManagerST.shared.request(fromURL: url) { [self] (result: Result<TeamList, Error>) in
            switch result {
            case let .success(response):
                //               let loaderArray =
//                dump(loaderArray)

                allTeamsData = response.data
                print(allTeamsData!.count)

                processAllTeamsData()

                debugPrint("We got a successful result with Team Data.")
            case let .failure(error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }

        func processAllTeamsData() {
            for i in 0 ..< allTeamsData!.count {
                let temp = TeamCard(context: context)

                temp.id = Int64(allTeamsData![i].id)
                temp.name = allTeamsData![i].name
                temp.image = allTeamsData![i].image_path

                dbLoaderTeams.append(temp)
            }

            saveItems()

            print("Finished")
        }
    }

    func process() {
        for i in 0 ..< receiveData!.count {
            let id = receiveData![i].id
            let name = receiveData![i].fullname ?? "Ahskor Menduo"
            let img = receiveData![i].image_path!
            let country = receiveData![i].country.name ?? ""
            let countryImage = receiveData![i].country.image_path!

            let temp = PlayerMiniInfo(id: id!, name: name, playerImg: img, country: country, countryImg: countryImage)

            playerList.append(temp)
        }
        print("load Complete")
        print(playerList.count)
        print("loading to cd started Called")
        saveToCoreData()
    }

    func saveToCoreData() {
        for i in 0 ..< playerList.count {
            let temp = PlayerCard(context: context)
            temp.id = Int64(playerList[i].id)
            temp.name = playerList[i].name
            temp.image = playerList[i].playerImg
            temp.country = playerList[i].country
            temp.countryImg = playerList[i].countryImg

            dbLoader.append(temp)
        }

        saveItems()

        print("Finished")
    }
}
