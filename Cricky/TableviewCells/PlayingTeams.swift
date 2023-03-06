//
//  PlayingTeams.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import UIKit

class PlayingTeams: UITableViewCell {
    @IBOutlet var teamImage: UIImageView!
    @IBOutlet var teamName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
