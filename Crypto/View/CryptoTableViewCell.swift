//
//  CryptoTableViewCell.swift
//  Crypto
//
//  Created by Daniil Marusenko on 21.03.2021.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var cryptoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
