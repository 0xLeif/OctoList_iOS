//
//  SUIKStyle.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/9/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit

protocol Styleable {
    func apply(style: SUIKStyle)
}

struct SUIKStyle {
    // Number Values
    var margin: Float = 0
    var padding: Float = 0
    var borderWidth: Float = 0
    var cornerRadius: Float = 0
    // Color Values
    var backgroundColor: UIColor = .clear
    var marginBackgroundColor: UIColor = .clear
    var borderColor: UIColor = .black
    var textColor: UIColor = .black
    
    func apply(styleTo view: Styleable) {
        view.apply(style: self)
    }
}

extension UILabel: Styleable {
    func apply(style: SUIKStyle) {
        textColor = style.textColor
    }
}

extension UIColor {
    var red: CGFloat {
        var r: CGFloat = 0
        
        getRed(&r, green: nil, blue: nil, alpha: nil)
        
        return r
    }
    
    var green: CGFloat {
        var g: CGFloat = 0
        
        getRed(nil, green: &g, blue: nil, alpha: nil)
        
        return g
    }
    
    var blue: CGFloat {
        var b: CGFloat = 0
        
        getRed(nil, green: nil, blue: &b, alpha: nil)
        
        return b
    }
    
    var alpha: CGFloat {
        var a: CGFloat = 0
        
        getRed(nil, green: nil, blue: nil, alpha: &a)
        
        return a
    }
}
