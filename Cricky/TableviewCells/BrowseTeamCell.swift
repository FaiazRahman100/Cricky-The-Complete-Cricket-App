//
//  BrowseTeamCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import UIKit

class BrowseTeamCell: UITableViewCell {
    @IBOutlet var bgView: UIView!
    @IBOutlet var teamImg: UIImageView!
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
