//
//  SeriesCell.swift
//  Cricky
//
//  Created by Faiaz Rahman on 19/2/23.
//

import UIKit

class SeriesCell: UITableViewCell {
    @IBOutlet var seriesImage: UIImageView!
    @IBOutlet var seriesName: UILabel!

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
