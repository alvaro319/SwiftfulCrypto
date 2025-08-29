//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/25/25.
//

import Foundation


extension String {
    
    var removingHTMLOccurences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
