//
//  OctoColor.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/13/20.
//  Copyright © 2020 oneleif. All rights reserved.
//
import UIKit

/// All values are from 0 - 1
struct OctoColor: Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
}

extension OctoColor {
    static var clear: OctoColor {
        OctoColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    static var black: OctoColor {
        OctoColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    static var white: OctoColor {
        OctoColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var defaultTint: OctoColor {
        OctoColor(red: 0, green: 0, blue: 1, alpha: 1)
    }
}

extension OctoColor: RawRepresentable {
    init?(rawValue: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        rawValue.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        self.init(red: r,
                  green: g,
                  blue: b,
                  alpha: a)
    }
    
    typealias RawValue = UIColor
    
    var uicolor: UIColor {
        return UIColor(red: red,
                green: green,
                blue: blue,
                alpha: alpha)
    }
    
    var rawValue: RawValue {
        uicolor
    }
}
