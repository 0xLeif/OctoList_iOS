//
//  EditViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/9/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

class EditViewController: UIViewController {
    public var editItemHandler: (ListItemData) -> Void
    
    private var listItem: ListItemData
    
    private var stackContainer = UIView(backgroundColor: .systemGray6).layer(cornerRadius: 4)
    
    init(item: ListItemData, editItemHandler: @escaping (ListItemData) -> Void) {
        self.listItem = item.copy
        self.editItemHandler = editItemHandler
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
                                Button("Cancel") {
                                    Navigate.shared.dismiss()
                                },
                                Spacer(),
                                Button("Save") { [weak self] in
                                    guard let self = self else {
                                        return
                                    }
                                    
                                    guard !self.listItem.title.isEmpty else {
                                        Navigate.shared.toast(style: .error, pinToTop: true, secondsToPersist: 1.5, padding: 8) {
                                            Label.headline("Title can not be empty!")
                                        }
                                        return
                                    }
                                    
                                    self.editItemHandler(self.listItem)
                                    Navigate.shared.dismiss()
                                }
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Title"),
                                Field(value: self.listItem.title, placeholder: "Title", keyboardType: .default)
                                    .configure { $0.borderStyle = .roundedRect }
                                    .inputHandler { [weak self] in self?.listItem.title = $0 }
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Notes"),
                                MultiLineField(value: self.listItem.notes, keyboardType: .default)
                                    .inputHandler { [weak self] in self?.listItem.notes = $0 }
                                    .layer(cornerRadius: 4)
                                    .layer(borderColor: .systemGray4)
                                    .layer(borderWidth: 1)
                                    .frame(height: 120)
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Section"),
                                Field(value: self.listItem.section ?? "", placeholder: "Work", keyboardType: .default)
                                    .configure { $0.borderStyle = .roundedRect }
                                    .inputHandler { [weak self] in self?.listItem.section = $0 }
                            ]
                        },
                        
                        VStack(withSpacing: 4) {
                            [
                                Label("Tags (Seperate tags with a comma)"),
                                Field(value: self.listItem.tags.joined(separator: ", "), placeholder: "Swift, iOS, SUIK", keyboardType: .default)
                                    .configure { $0.borderStyle = .roundedRect }
                                    .inputHandler { [weak self] in self?.listItem.tags = $0.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map(String.init) }
                            ]
                        },
                        
                        Spacer()
                    ]
                }
            }
        }
        
        view.background(color: .white)
            .embed { self.stackContainer }
    }
    
}
