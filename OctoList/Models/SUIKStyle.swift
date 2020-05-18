//
//  SUIKStyle.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/9/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import FluentSQLite

protocol Styleable {
    func apply(style: SUIKStyle)
}

struct SUIKStyle: SQLiteModel {
    var id: Int?
    // Number Values
    var margin: Float = 0
    var padding: Float = 0
    var borderWidth: Float = 0
    var cornerRadius: Float = 0
    var numberOfLines: Int = 3
    // Color Values
    var backgroundColor: OctoColor = .white
    var marginBackgroundColor: OctoColor = .clear
    var borderColor: OctoColor = .black
    var textColor: OctoColor = .black
    
    func apply(styleTo view: Styleable) {
        view.apply(style: self)
    }
}

extension SUIKStyle: Migration { }

// MARK: Styleable

extension UILabel: Styleable {
    func apply(style: SUIKStyle) {
        textColor = style.textColor.uicolor
        numberOfLines = style.numberOfLines
    }
}
