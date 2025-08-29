//
//  Double.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/30/25.
//

import Foundation

extension Double {
    
    ///Converts a Double into a currency with 2 decimal digits
    ///```
    /// Convert 1234.56 to $1,234.56
    ///```
    ///Hold the option button down and highlight currencyFormatter2 to see what XCode shows you
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true//for the commas in a number: 1,000
        formatter.numberStyle = .currency
        //defaults
        /*
        formatter.locale = .current //default
        formatter.currencyCode = "usd"//for currency type
        formatter.currencySymbol = "$"//for currency symbol
         */
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    //asCurrencyWithDecimal()
    /*
    Because this is an extension for a Double, any Double variable can call
    on this function so it can be formatted
    Usage:
     var myPrice: Double = 5.00
     myPrice.asCurrencyWithDecimal() and self below is myPrice, the calling object
     */
    /// Converts a Double into a Currency as a String with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// ```
    func asCurrencyWith2Decimal() -> String {
        //we can initialize NSNumber with any value type such as an Int, Double,
        //Float, UInt16, Int16, etc.
        //In our case we use a Double because we are in a Double extension

        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }

    ///Converts a Double into a currency with 2-6 decimal digits
    ///```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    ///```
    ///Hold the option button down and highlight currencyFormatter6 to see what XCode shows you
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true//for the commas in a number: 1,000
        formatter.numberStyle = .currency
        //defaults
        /*
        formatter.locale = .current //default
        formatter.currencyCode = "usd"//for currency type
        formatter.currencySymbol = "$"//for currency symbol
         */
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    //asCurrencyWithDecimal()
    /*
    Because this is an extension for a Double, any Double variable can call
    on this function so it can be formatted
    Usage:
     var myPrice: Double = 5.00
     myPrice.asCurrencyWithDecimal() and self below is myPrice, the calling object
     */
    /// Converts a Double into a Currency as a String with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert 0.123456 to "$0.123456"
    /// ```
    func asCurrencyWith6Decimal() -> String {
        //we can initialize NSNumber with any value type such as an Int, Double,
        //Float, UInt16, Int16, etc.
        //In our case we use a Double because we are in a Double extension

        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Converts a Double into a String representation
    /// ```
    /// Convert 1.23456 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double into a percent String representation
    /// ```
    /// Convert 1.23456 to "1.23%"
    /// ```
    func asPercentString() -> String {
        asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }
}
