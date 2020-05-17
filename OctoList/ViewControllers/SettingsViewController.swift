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
import FLite

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navigate.shared.set(title: "Settings")
        
        view.background(color: .white).embed {
            Table(defaultCellHeight: 60) {
                [
                    Button({ Navigate.shared.go(CellCustomizeViewController(), style: .push) }) {
                        HStack {
                            [
                                Label.body("Cell Customization"),
                                Spacer()
                            ]
                        }
                        .padding(16)
                    }
                ]
            }
            .configure { $0.allowsSelection = false }
            .configureCell { $0.accessoryType = .disclosureIndicator }
        }
    }
    
}
