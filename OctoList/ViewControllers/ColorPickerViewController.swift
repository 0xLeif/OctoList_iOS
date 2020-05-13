//
//  ColorPickerViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/12/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

class ColorPickerViewController: UIViewController {
    weak var styledView: StyleView?
    weak var currentBackgroundColorView: UIView?
    
    deinit {
        print("DEINIT ColorPickerViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        view.embed {
            SafeAreaView {
                VStack {
                    [
                        UIView(backgroundColor: .white) {
                            VStack {
                                [
                                    Label("Red"),
                                    Slider(value: Float(globalStyle.backgroundColor.red), from: 0, to: 1) { [weak self] (red) in
                                        globalStyle.backgroundColor = UIColor(red: CGFloat(red),
                                                                              green: globalStyle.backgroundColor.green,
                                                                              blue: globalStyle.backgroundColor.blue,
                                                                              alpha: globalStyle.backgroundColor.alpha)
                                        self?.updateViews()
                                    },
                                    Label("Green"),
                                    Slider(value: Float(globalStyle.backgroundColor.green), from: 0, to: 1) { [weak self] (green) in
                                        globalStyle.backgroundColor = UIColor(red: globalStyle.backgroundColor.red,
                                                                              green: CGFloat(green),
                                                                              blue: globalStyle.backgroundColor.blue,
                                                                              alpha: globalStyle.backgroundColor.alpha)
                                        self?.updateViews()
                                    },
                                    Label("Blue"),
                                    Slider(value: Float(globalStyle.backgroundColor.blue), from: 0, to: 1) { [weak self] (blue) in
                                        globalStyle.backgroundColor = UIColor(red: globalStyle.backgroundColor.red,
                                                                              green: globalStyle.backgroundColor.green,
                                                                              blue: CGFloat(blue),
                                                                              alpha: globalStyle.backgroundColor.alpha)
                                        self?.updateViews()
                                    },
                                    Label("Alpha"),
                                    Slider(value: Float(globalStyle.backgroundColor.alpha), from: 0, to: 1) { [weak self] (alpha) in
                                        globalStyle.backgroundColor = UIColor(red: globalStyle.backgroundColor.red,
                                                                              green: globalStyle.backgroundColor.green,
                                                                              blue: globalStyle.backgroundColor.blue,
                                                                              alpha: CGFloat(alpha))
                                        self?.updateViews()
                                    }
                                ]
                            }
                        }
                        .padding()
                        .layer(cornerRadius: 8),
                        Spacer().background(color: .clear)
                    ]
                }
            }
        }
    }
    
    private func updateViews() {
        view.background(color: globalStyle.backgroundColor)
        
        styledView?.apply(style: globalStyle)
        currentBackgroundColorView?.background(color: globalStyle.backgroundColor)
    }
}
