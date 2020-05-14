//
//  SettingsViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/13/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import EKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navigate.shared.set(title: "Settings")
        
        view.background(color: .white).embed {
            Table(defaultCellHeight: 60) {
                [
                    Label.title1("Customization").padding(),
                    Button({ Navigate.shared.go(CellCustomizeViewController(), style: .push) }) {
                        HStack {
                            [
                                Label.headline("Cell"),
                                Spacer(),
                                Label(E.right_arrow.rawValue)
                            ]
                        }
                        .padding()
                    },
                    VStack {
                        [
                            Label.headline("App Tint Color"),
                            Button({ [weak self] in
                                guard let self = self else {
                                    return
                                }
                                Navigate.shared.go(ColorPickerViewController(color: globalStyle.appTintColor, forView: nil) { [weak self] in
                                    guard let self = self else {
                                        return
                                    }
                                    globalStyle.appTintColor = $0
                                    self.view.allSubviews.forEach { $0.tintColor = globalStyle.appTintColor.uicolor }
                                }, style: .push)
                                
                            }) {
                                HStack {
                                    [
                                        Label.headline("Color"),
                                        Spacer(),
                                        Label(E.right_arrow.rawValue)
                                    ]
                                }
                                .padding()
                                
                            }
                        ]
                    }
                ]
            }
            .configure { $0.allowsSelection = false }
        }
    }
    
}
