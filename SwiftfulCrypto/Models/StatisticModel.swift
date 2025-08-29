//
//  StatisticModel.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/9/25.
//

import Foundation

struct StatisticModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    
    //usage for when you don't have a percentageChange:
    //let newModel2 = StatisticModel(title: "", value: "")//defaults percentateChange to nil
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
