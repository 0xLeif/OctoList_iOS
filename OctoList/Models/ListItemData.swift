//
//  ListItemData.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/1/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import Foundation
import SwiftUIKit
import FluentSQLite

final class ListItemData: SQLiteModel {
    var id: Int?
    
    private var createdDate: Date = Date()
    private var lastEdited: Date = Date()
    var section: String?
    
    var title: String = ""
    var notes: String = ""
    var tags: [String] = []
    
    var date: Date?
}

extension ListItemData: Codable { }
extension ListItemData: Migration { }
extension ListItemData: CellDisplayable {
    var cellID: String {
        ListItemCell.ID
    }
}

extension ListItemData {
    func configure(closure: (ListItemData) -> Void) -> ListItemData {
        closure(self)
        
        return self
    }
}

extension ListItemData {
    convenience init(item: ListItemData) {
        self.init()
        id = item.id
        lastEdited = item.lastEdited
        section = item.section
        title = item.title
        notes = item.notes
        tags = item.tags
        date = item.date
    }
    
    var copy: ListItemData {
        ListItemData(item: self)
    }
}
