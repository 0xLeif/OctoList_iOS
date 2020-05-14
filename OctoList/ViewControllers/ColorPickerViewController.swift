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
    deinit {
        print("DEINIT ColorPickerViewController")
    }
    
    weak var currentBackgroundColorView: UIView?
    
    private var color: OctoColor
    private var saveHandler: (OctoColor) -> Void
    
    init(color: OctoColor, forView view: UIView?, _ saveHandler: @escaping (OctoColor) -> Void) {
        self.color = color
        self.currentBackgroundColorView = view
        self.saveHandler = saveHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navigate.shared.setRight(barButton: UIBarButtonItem {
            Button("Done") { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.saveHandler(self.color)

                self.currentBackgroundColorView?.background(color: self.color.uicolor)
                
                Navigate.shared.back()
            }
        })
        
        updateViews()
        
        view.embed {
            SafeAreaView {
                VStack {
                    [
                        UIView(backgroundColor: .white) {
                            VStack {
                                [
                                    Label("Red"),
                                    Slider(value: Float(self.color.red), from: 0, to: 1) { [weak self] (red) in
                                        guard let self = self else {
                                            return
                                        }
                                        
                                        self.color = OctoColor(red: CGFloat(red),
                                                                              green: self.color.green,
                                                                              blue: self.color.blue,
                                                                              alpha: self.color.alpha)
                                        self.updateViews()
                                    },
                                    Label("Green"),
                                    Slider(value: Float(self.color.green), from: 0, to: 1) { [weak self] (green) in
                                        guard let self = self else {
                                            return
                                        }
                                        
                                        self.color = OctoColor(red: self.color.red,
                                                                              green: CGFloat(green),
                                                                              blue: self.color.blue,
                                                                              alpha: self.color.alpha)
                                        self.updateViews()
                                    },
                                    Label("Blue"),
                                    Slider(value: Float(self.color.blue), from: 0, to: 1) { [weak self] (blue) in
                                        guard let self = self else {
                                            return
                                        }
                                        
                                        self.color = OctoColor(red: self.color.red,
                                                                              green: self.color.green,
                                                                              blue: CGFloat(blue),
                                                                              alpha: self.color.alpha)
                                        self.updateViews()
                                    },
                                    Label("Alpha"),
                                    Slider(value: Float(self.color.alpha), from: 0, to: 1) { [weak self] (alpha) in
                                        guard let self = self else {
                                            return
                                        }
                                        
                                        self.color = OctoColor(red: self.color.red,
                                                                              green: self.color.green,
                                                                              blue: self.color.blue,
                                                                              alpha: CGFloat(alpha))
                                        self.updateViews()
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
        view.background(color: color.uicolor)
    }
}
