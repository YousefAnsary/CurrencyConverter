//
//  CurrencyTableCell.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import UIKit

class CurrencyTableCell: UITableViewCell {

    @IBOutlet private weak var countryImgView: UIImageView!
    @IBOutlet private weak var currencyLbl: UILabel!
    @IBOutlet private weak var fractionLbl: UILabel!
    
    var currency: Currency! {
        didSet {
            countryImgView.image = currency.image
            currencyLbl.text = currency.code
            fractionLbl.text = "\(currency.fraction)"
        }
    }

}
