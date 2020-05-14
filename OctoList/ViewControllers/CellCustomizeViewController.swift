//
//  CellCustomizeViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/9/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import FLite

class CellCustomizeViewController: UIViewController {
    private var style = globalStyle
    private let currentBackgroundColorView = UIView()
    private lazy var styledView = StyleView(style: self.style) {
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
        
        Navigate.shared.setRight(barButton: UIBarButtonItem {
            Button("Save") { [weak self] in
                guard let self = self else {
                    return
                }
                
                Navigate.shared.toast(style: .info, pinToTop: true) {
                    LoadingView().start()
                }
                
                globalStyle = self.style
                
                FLite.connection
                    
                    .then { (connection) in
                        globalStyle.update(on: connection)
                }
                .catch { (error) in
                    print("\(error.localizedDescription)")
                }
                .whenComplete {
                    DispatchQueue.main.async {
                        Navigate.shared.destroyToast()
                        Navigate.shared.back()
                    }
                }
            }
        })
        
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
                                                Slider(value: self.style.margin, from: 0, to: 32) { [weak self] value in
                                                    guard let self = self else {
                                                        return
                                                    }
                                                    
                                                    self.style.margin = value
                                                    self.styledView.apply(style: self.style)
                                                }
                                                .padding(4)
                                            ]
                                            
                                        },
                                        
                                        VStack {
                                            [
                                                Label.headline("Padding"),
                                                Slider(value: self.style.padding, from: 0, to: 32) { [weak self] value in
                                                    guard let self = self else {
                                                        return
                                                    }
                                                    
                                                    self.style.padding = value
                                                    self.styledView.apply(style: self.style)
                                                }
                                                .padding(4)
                                            ]
                                        },
                                        
                                        VStack {
                                            [
                                                Label.headline("Border width"),
                                                Slider(value: self.style.borderWidth, from: 0, to: 12) { [weak self] value in
                                                    guard let self = self else {
                                                        return
                                                    }
                                                    
                                                    self.style.borderWidth = value
                                                    self.styledView.apply(style: self.style)
                                                }
                                                .padding(4)
                                            ]
                                        },
                                        
                                        VStack {
                                            [
                                                Label.headline("Corner Radius"),
                                                Slider(value: self.style.cornerRadius, from: 0, to: 16) { [weak self] value in
                                                    guard let self = self else {
                                                        return
                                                    }
                                                    
                                                    self.style.cornerRadius = value
                                                    self.styledView.apply(style: self.style)
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
                                                    Navigate.shared.go(ColorPickerViewController(color: globalStyle.backgroundColor, forView: self.currentBackgroundColorView) { [weak self] in
                                                        guard let self = self else {
                                                            return
                                                        }
                                                        self.style.backgroundColor = $0
                                                        self.styledView.apply(style: self.style)
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
                                                                .background(color: self.style.backgroundColor.uicolor)
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
