//
//  MatchesCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import UIKit

class MatchesCell: UITableViewCell {
    @IBOutlet var stageLabel: UILabel!

    @IBOutlet var dateLabel: UILabel!

    @IBOutlet var StatusLabel: UILabel!
    @IBOutlet var team1Score: UILabel!

    @IBOutlet var team2Score: UILabel!

    @IBOutlet var team1Code: UILabel!
    @IBOutlet var team2Code: UILabel!

    @IBOutlet var team1Img: UIImageView!
    @IBOutlet var team2Img: UIImageView!

    @IBOutlet var team1Over: UILabel!

    @IBOutlet var team2Over: UILabel!

    @IBOutlet var resultLabel: UILabel!

    @IBOutlet var bgView: UIView!

    @IBOutlet var statusView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
