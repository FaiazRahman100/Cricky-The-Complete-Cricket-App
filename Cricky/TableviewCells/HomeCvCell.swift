//
//  HomeCvCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import UIKit

class HomeCvCell: UICollectionViewCell {
    @IBOutlet var stageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    @IBOutlet var StatusLabel: UILabel!
    @IBOutlet var team1Score: UILabel!

    @IBOutlet var venueMiddle: UILabel!
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

    @IBOutlet var middleView: UILabel!
    @IBOutlet var arrowImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
