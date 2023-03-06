//
//  RankingCell.swift
//  Cricky
//
//  Created by bjit on 22/2/23.
//

import UIKit

class RankingCell: UITableViewCell {
    @IBOutlet var rank: UILabel!
    @IBOutlet var teamImage: UIImageView!
    @IBOutlet var matches: UILabel!
    @IBOutlet var points: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var bgView: UIView!

    @IBOutlet var countryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
