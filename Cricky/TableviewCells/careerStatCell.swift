//
//  careerStatCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 21/2/23.
//

import UIKit

class careerStatCell: UITableViewCell {
    @IBOutlet var bgView: UIView!

    @IBOutlet var odi: UILabel!
    @IBOutlet var t20I: UILabel!
    @IBOutlet var domestic: UILabel!
    @IBOutlet var field: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
