//
//  BallingCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 22/2/23.
//

import UIKit

class BallingCell: UITableViewCell {
    @IBOutlet var bawlerName: UILabel!

    @IBOutlet var Over: UILabel!

    @IBOutlet var bgView: UIView!
    @IBOutlet var maiden: UILabel!

    @IBOutlet var sR: UILabel!
    @IBOutlet var wicket: UILabel!
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
