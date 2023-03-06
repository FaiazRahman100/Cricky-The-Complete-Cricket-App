//
//  LeagueCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import UIKit

class LeagueCell: UITableViewCell {
    @IBOutlet var LeagueImage: UIImageView!
    @IBOutlet var leagueName: UILabel!
    @IBOutlet var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
