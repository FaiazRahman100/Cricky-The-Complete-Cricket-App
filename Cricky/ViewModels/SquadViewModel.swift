//
//  SquadViewModel.swift
//  Cricky
//
//  Created by Faiaz Rahman on 20/2/23.
//

import Foundation

class SquadViewModel {
    var teamList: ObservableObject<[TeamX]?> = ObservableObject(nil)

    var tableArray: TeamX?
}
