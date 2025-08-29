//
//  HapticsManager.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/18/25.
//

import Foundation
import SwiftUI

class HapticsManager {
    
    static private let generator =  UINotificationFeedbackGenerator()
    
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
