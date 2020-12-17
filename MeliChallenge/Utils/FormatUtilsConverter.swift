//
//  Tools.swift
//  MeliChallenge
//
//  Created by lucas depetris on 16/12/2020.
//

import Foundation

public class FormatUtilsConverter {
    
    class func toCurrency(_ price: Double) -> String{
                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = NumberFormatter.Style.currencyAccounting
                    formatter.usesGroupingSeparator = true
                    formatter.maximumFractionDigits = 2
                    if let str = formatter.string(for: price) {
                        return str
                    }
        return ""
        }
}
