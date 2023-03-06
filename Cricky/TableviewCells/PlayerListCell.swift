//
//  PlayerListCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 20/2/23.
//

import UIKit

class PlayerListCell: UITableViewCell {
    @IBOutlet var playerType: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var playerPosition: UILabel!
    @IBOutlet var playerName: UILabel!
    @IBOutlet var playerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
