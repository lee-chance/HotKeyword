//
//  HotKeywordColor.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/09.
//

import SwiftUI

extension Color {
    static var text: Color {
        Color(
            light: Color.black,
            dark: Color.white
        )
    }
    
    static var gold: Color {
        Color(red: 253 / 255, green: 208 / 255, blue: 23 / 255)
    }
    
    static var silver: Color {
        Color(red: 192 / 255, green: 192 / 255, blue: 192 / 255)
    }
    
    static var bronze: Color {
        Color(red: 184 / 255, green: 115 / 255, blue: 51 / 255)
    }
    
    static var mainOrange: Color {
        Color("mainOrange")
    }
    
    static var mainYellow: Color {
        Color("mainYellow")
    }
    
    static var mainCenterColor: Color {
        Color("mainCenterColor")
    }
}

extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
     ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            default:
                return lightModeColor()
            }
        }
    }
}

extension Color {
    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: UIColor(lightModeColor()),
            dark: UIColor(darkModeColor())
        ))
    }
}
