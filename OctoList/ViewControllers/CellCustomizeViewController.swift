//
//  CellCustomizeViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/9/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

class CellCustomizeViewController: UIViewController {
    private let currentBackgroundColorView = UIView()
    private var styledView = StyleView(style: globalStyle) {
        VStack(withSpacing: 4) {
            [
                Label.title1("SOME TITLE"),
                Label.body("THIS IS THE FIRST NOTE")
                    .number(ofLines: 5)
            ]
        }
    }
    
    deinit {
        print("DEINIT CellCustomizeViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        draw()
    }
    
    private func draw() {
        
        view.clear()
            .embed {
                UIView(backgroundColor: .white) {
                    SafeAreaView {
                        VStack(withSpacing: 32) {
                            [
                                self.styledView,
                                Table {
                                    [
                                        VStack {
                                            [
                                                Label.headline("Margin"),
                                                Slider(value: globalStyle.margin, from: 0, to: 32) { [weak self] value in
                                                    globalStyle.margin = value
                                                    self?.styledView.apply(style: globalStyle)
                                                }
                                                .padding(4)
                                            ]
                                            
                                        },
                                        
                                        VStack {
                                            [
                                                Label.headline("Padding"),
                                                Slider(value: globalStyle.padding, from: 0, to: 32) { [weak self] value in
                                                    globalStyle.padding = value
                                                    self?.styledView.apply(style: globalStyle)
                                                }
                                                .padding(4)
                                            ]
                                        },
                                        
                                        VStack {
                                            [
                                                Label.headline("Border width"),
                                                Slider(value: globalStyle.borderWidth, from: 0, to: 12) { [weak self] value in
                                                    globalStyle.borderWidth = value
                                                    self?.styledView.apply(style: globalStyle)
                                                }
                                                .padding(4)
                                            ]
                                        },
                                        
                                        VStack {
                                            [
                                                Label.headline("Corner Radius"),
                                                Slider(value: globalStyle.cornerRadius, from: 0, to: 16) { [weak self] value in
                                                    globalStyle.cornerRadius = value
                                                    self?.styledView.apply(style: globalStyle)
                                                }
                                                .padding(4)
                                            ]
                                        },
                                        
                                        VStack {
                                            [
                                                Label.headline("Background Color"),
                                                Button({ [weak self] in
                                                    guard let self = self else {
                                                        return
                                                    }
                                                    Navigate.shared.go(ColorPickerViewController()
                                                        .configure { [weak self] in
                                                            $0.styledView = self?.styledView
                                                            $0.currentBackgroundColorView = self?.currentBackgroundColorView
                                                    }, style: .push)
                                                    
                                                }) {
                                                    HStack {
                                                        [
                                                            Label("Set Color"),
                                                            Spacer(),
                                                            self.currentBackgroundColorView
                                                                .frame(width: 44)
                                                                .layer(borderWidth: 1)
                                                                .layer(borderColor: .black)
                                                                .layer(cornerRadius: 8)
                                                                .background(color: globalStyle.backgroundColor)
                                                        ]
                                                    }
                                                    .frame(height: 44)
                                                    .padding(4)
                                                    
                                                }
                                            ]
                                        }
                                    ]
                                }.configure { $0.separatorStyle = .none }
                            ]
                        }
                        
                    }
                    
                }
        }
    }
}
