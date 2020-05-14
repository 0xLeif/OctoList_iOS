//
//  DetailViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 4/29/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import FLite
import EKit

class DetailViewController: UIViewController {
    public var updateItemHandler: (ListItemData) -> Void
    public var item: ListItemData
    
    private var stackContainer = UIView().layer(cornerRadius: 4)
    
    init(item: ListItemData, updateItemHandler: @escaping (ListItemData) -> Void) {
        self.item = item
        self.updateItemHandler = updateItemHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navigate.shared.setRight(barButton: BarButton {
            Button("Edit", titleColor: view.tintColor) {
                Navigate.shared.go(EditViewController(item: self.item) { [weak self] edittedItem in
                    self?.item = edittedItem
                    DispatchQueue.main.async {
                        self?.draw()
                    }
                    FLite.connection.do { (connection) in
                        self?.item.update(on: connection).do { (item) in
                            self?.updateItemHandler(item)
                        }
                        .catch { print($0.localizedDescription) }
                    }
                    .catch { print($0.localizedDescription) }
                }, style: .modal)
            }
        })
        
        
        
        draw()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            self.stackContainer.update(width: Float(self.view.bounds.width))
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        draw()
    }
    
    private func draw() {
        stackContainer.clear().embed {
            SafeAreaView {
                VStack {
                    [
                        Label.title1(self.item.title),
                        Label.body(self.item.notes).number(ofLines: 100),
                        Label.caption1(self.item.tags.joined(separator: ", ")),
                        Spacer()
                    ]
                }
            }
        }
        
        view.clear()
            .background(color: traitCollection.userInterfaceStyle == .dark ? .black : .white)
            .embed {
                ScrollView {
                    self.stackContainer
                        .frame(width: Float(self.view.bounds.width))
                }
        }
    }
}
