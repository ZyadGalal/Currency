//
//  LastDaysTableViewCell.swift
//  Currency
//
//  Created by Zyad Galal on 23/02/2022.
//

import UIKit

class LastDaysTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(date: String, fromCurrency: String, toCurrency: String, convertedRate: String) {
        currencyLabel.text = "1 \(fromCurrency) = \(convertedRate) \(toCurrency)"
        dateLabel.text = date
    }
}
