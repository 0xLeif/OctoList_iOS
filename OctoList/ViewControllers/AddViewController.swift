//
//  AddViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 4/29/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import EKit

class AddViewController: UIViewController {
    public var addItemHandler: (ListItemData) -> Void
    
    private var listItem = ListItemData()
    
    private var stackContainer = UIView(backgroundColor: .systemGray6).layer(cornerRadius: 4)
    
    init(addItemHandler: @escaping (ListItemData) -> Void) {
        self.addItemHandler = addItemHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackContainer.embed {
            SafeAreaView {
                VStack(withSpacing: 8) {
                    [
                        HStack {
                            [
                                Button("Cancel", titleColor: view.tintColor) {
                                    Navigate.shared.back()
                                },
                                Spacer(),
                                Button("Add", titleColor: view.tintColor) { [weak self] in
                                    guard let self = self else {
                                        return
                                    }
                                    
                                    guard !self.listItem.title.isEmpty else {
                                        Navigate.shared.toast(style: .error, pinToTop: true, secondsToPersist: 1.5, padding: 8) {
                                            Label.headline("Title can not be empty!")
                                        }
                                        return
                                    }
                                    
                                    self.addItemHandler(self.listItem)
                                    Navigate.shared.back()
                                }
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Title"),
                                Field(value: "", placeholder: "Title", keyboardType: .default)
                                    .configure { $0.borderStyle = .roundedRect }
                                    .inputHandler { self.listItem.title = $0 }
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Notes"),
                                MultiLineField(value: "", keyboardType: .default)
                                    .inputHandler {  self.listItem.notes = $0 }
                                    .layer(cornerRadius: 4)
                                    .layer(borderColor: .systemGray4)
                                    .layer(borderWidth: 1)
                                    .frame(height: 120)
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Section"),
                                Field(value: "", placeholder: "Work", keyboardType: .default)
                                    .configure { $0.borderStyle = .roundedRect }
                                    .inputHandler { self.listItem.section = $0 }
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Tags (Seperate tags with a comma)"),
                                Field(value: "", placeholder: "Swift, iOS, SUIK", keyboardType: .default)
                                    .configure { $0.borderStyle = .roundedRect }
                                    .inputHandler { self.listItem.tags = $0.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map(String.init) }
                            ]
                        },
                        
                        Spacer()
                    ]
                }
            }
        }
        
        view.background(color: .white)
            .embed {
                //                ScrollView {
                self.stackContainer
                //                        .frame(width: Float(self.view.bounds.width))
                //                }
        }
    }
    
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        super.viewWillTransition(to: size, with: coordinator)
    //
    //        coordinator.animate(alongsideTransition: nil) { _ in
    //            self.stackContainer.update(width: Float(self.view.bounds.width))
    //        }
    //    }
    
}
