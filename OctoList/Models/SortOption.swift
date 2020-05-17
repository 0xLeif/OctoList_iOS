//
//  SortOption.swift
//  OctoList
//
//  Created by Zach Eriksen on 5/17/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import Foundation

enum SortMethod {
    case alphabetical(ascending: Bool)
}

enum ListItemDataOption {
    case section
    case title
    case tags
}

extension ListItemDataOption {
    func value(forData data: ListItemData) -> String {
        switch self {
        case .section:
            return data.section ?? ""
        case .title:
            return data.title
        case .tags:
            return data.tags.joined(separator: ", ")
        }
    }
}

struct SortOption {
    let sectionDataOption: ListItemDataOption
    let sectionSortMethod: SortMethod
    let dataOption: ListItemDataOption
    let sortMethod: SortMethod
}

extension SortOption {
    func sectionSortMethod(forKey lhs: String, and rhs: String) -> Bool {
        switch sectionSortMethod {
        case .alphabetical(let ascending):
            return ascending ? lhs < rhs : lhs > rhs
        }
    }
    
    func sortMethod(forSection section: [ListItemData]) -> [ListItemData] {
        switch sortMethod {
        case .alphabetical(let ascending):
            return section.sorted { (lhs, rhs) -> Bool in
                ascending ? dataOption.value(forData: lhs) < dataOption.value(forData: rhs) :
                            dataOption.value(forData: lhs) > dataOption.value(forData: rhs)
            }
        }
    }
}

extension Collection where Element == ListItemData {
    func sorted(by option: SortOption) -> [[Element]] {
        self
            // Option
            .map { (option.sectionDataOption.value(forData: $0), $0) }
            .reduce([String: [ListItemData]]()) { (dictionary: [String: [ListItemData]], keyValueTuple: (String?, ListItemData)) -> [String: [ListItemData]] in
                var reduceDictionary = dictionary
                
                guard var array = reduceDictionary[keyValueTuple.0 ?? ""] else {
                    reduceDictionary[keyValueTuple.0 ?? ""] = [keyValueTuple.1]
                    return reduceDictionary
                }
                
                array.append(keyValueTuple.1)
                reduceDictionary[keyValueTuple.0 ?? ""] = array
                
                return reduceDictionary
        }
            // Sort
            .sorted(by: { (lhs, rhs) -> Bool in
                return option.sectionSortMethod(forKey: lhs.key, and: rhs.key)
            })
            .map {
                option.sortMethod(forSection:
                $0.value)
                
        }
    }
    //    private var newTableData: [[ListItemData]] {
    //        data
    //            .map { ($0.section, $0) }
    //            .reduce([String: [ListItemData]]()) { (dictionary: [String: [ListItemData]], keyValueTuple: (String?, ListItemData)) -> [String: [ListItemData]] in
    //                var reduceDictionary = dictionary
    //
    //                guard var array = reduceDictionary[keyValueTuple.0 ?? ""] else {
    //                    reduceDictionary[keyValueTuple.0 ?? ""] = [keyValueTuple.1]
    //                    return reduceDictionary
    //                }
    //
    //                array.append(keyValueTuple.1)
    //                reduceDictionary[keyValueTuple.0 ?? ""] = array
    //
    //                return reduceDictionary
    //        }
    //        .sorted(by: { (lhs, rhs) -> Bool in
    //            return lhs.key < rhs.key
    //        })
    //        .map { $0.value }
    //    }
}
