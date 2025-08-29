//
//  Date.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/24/25.
//

import Foundation

extension Date {
    
    //"2021-03-13T20:49:26.606Z"
    init(coinGeckoString: String) {
        
        //formats the incoming string example in comments above
        //into a more readable format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    //converts Date to String
    //computed property
    private var shortFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    //whichever String object that calls this function,
    //will make use of the shortFormatter computed property
    //the calling object itself is used for the computed property
    //so that its date can be formatted to a short form
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
