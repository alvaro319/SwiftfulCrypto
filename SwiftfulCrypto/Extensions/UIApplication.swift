//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/6/25.
//

import Foundation
import UIKit


extension UIApplication {
    
    //dismisses keyboard and ends any other editing on the device
    //Notifies this object that it has been asked to relinquish
    //its status as first responder in its window.
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
