//
//  ListItemCell.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/1/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

class ListItemCell: UITableViewCell {
    let title = Label.title1("")
    let notes = Label.body("")
    lazy var styleView = StyleView(style: globalStyle) {
        VStack(withSpacing: 4) {
            [
                self.title,
                self.notes
                    .number(ofLines: 5)
            ]
        }
    }
}

extension ListItemCell: TableViewCell {
    func configure(forData data: CellDisplayable) {
        contentView.clear().embed {
            styleView
        }
        
        selectionStyle = .none
    }
    
    func update(forData data: CellDisplayable) {
        guard let data = data as? ListItemData else {
            return
        }
        
        title.text = data.title
        notes.text = data.notes
        
        UIView.animate(withDuration: 0.314,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: { self.styleView.apply(style: globalStyle) },
                       completion: nil)
    }
    
    static var ID: String {
        "ListItemCell"
    }
}
