//
//  BattingCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 22/2/23.
//

import UIKit

class BattingCell: UITableViewCell {
    @IBOutlet var outStatusHeight: NSLayoutConstraint!

    @IBOutlet var batsmanName: UILabel!

    @IBOutlet var outStatus: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet var sR: UILabel!
    @IBOutlet var six: UILabel!
    @IBOutlet var four: UILabel!
    @IBOutlet var ball: UILabel!
    @IBOutlet var run: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
