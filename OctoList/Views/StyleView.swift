//
//  StyleView.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/9/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

class StyleView: UIView {
    private var view: UIView
    
    init(style: SUIKStyle, closure: () -> UIView) {
        self.view = closure().padding(style.padding)
        super.init(frame: .zero)
        
        
        embed(withPadding: style.margin) {
            view
                .background(color: style.backgroundColor.uicolor)
                .layer(borderColor: style.borderColor.uicolor)
                .layer(borderWidth: style.borderWidth)
                .layer(cornerRadius: style.cornerRadius)
        }
        .background(color: style.marginBackgroundColor.uicolor)
        .apply(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StyleView: Styleable {
    func apply(style: SUIKStyle) {
        // Update StyleView
        update(padding: style.margin)
            .background(color: style.marginBackgroundColor.uicolor)
        
        // Update Padding with View
        view
            .update(padding: style.padding)
            .background(color: style.backgroundColor.uicolor)
            .layer(borderColor: style.borderColor.uicolor)
            .layer(borderWidth: style.borderWidth)
            .layer(cornerRadius: style.cornerRadius)
        
        // Update Subviews
        allSubviews
            .compactMap { $0 as? Styleable }
            .forEach { $0.apply(style: style) }
        
        layoutIfNeeded()
    }
}
