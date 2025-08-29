//
//  Color.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/29/25.
//

import Foundation
import SwiftUI

//extending the Color class, import SwiftUI
//by defining theme as static, we can access theme like this:
//Color.theme.accentColor or
//Color.theme.backgroundColor, etc.....
extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
    
    //if we ever wanted to change up our color theme
    //to ColorTheme2() instead of ColorTheme()
    //static let theme = ColorTheme2()
}

struct ColorTheme {
    
    let accentColor = Color("AccentColor")
    let backgroundColor = Color("BackgroundColor")
    //couldn't use GreenColor, got a conflicting warning
    let greenColor = Color("CustomGreenColor")
    //couldn't use RedColor, got a conflicting warning
    let redColor = Color("CustomRedColor")
    let secondaryTextColor = Color("SecondaryTextColor")
}

struct LaunchTheme {
    let accentColor = Color("LaunchAccentColor")
    let backgroundColor = Color("LaunchBackgroundColor")
}

//Whole new color theme we could add later on, if need be
//these color literals are not adaptive meaning they are the
//the same in light and dark mode
struct ColorTheme2 {
    //to get colorLiteral type:
    //#colorLiteral(
    let accentColor = Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))
    let backgroundColor = Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
    //couldn't use GreenColor, got a conflicting warning
    let greenColor = Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
    //couldn't use RedColor, got a conflicting warning
    let redColor = Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    let secondaryTextColor = Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))
}
