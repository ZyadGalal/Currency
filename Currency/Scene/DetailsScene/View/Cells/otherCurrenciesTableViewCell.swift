//
//  otherCurrenciesTableViewCell.swift
//  Currency
//
//  Created by Zyad Galal on 23/02/2022.
//

import UIKit

class otherCurrenciesTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(fromCurrency: String, convertedAmount: Double, toCurrency: String) {
        currencyLabel.text = "1 \(fromCurrency) = \(convertedAmount) \(toCurrency)"
    }
    
}
