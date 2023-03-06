//
//  browsePlayerCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 24/2/23.
//

import UIKit

class browsePlayerCell: UITableViewCell {
    @IBOutlet var countryName: UILabel!
    @IBOutlet var playerName: UILabel!
    @IBOutlet var countryImg: UIImageView!
    @IBOutlet var playerImage: UIImageView!
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
