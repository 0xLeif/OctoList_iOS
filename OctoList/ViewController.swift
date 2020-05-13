//
//  ViewController.swift
//  OctoList
//
//  Created by Zach Eriksen on 4/25/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import FLite
import EKit

var globalStyle = SUIKStyle()
class ViewController: UIViewController {
    // MARK: Data
    private(set) var currentTableData: [[ListItemData]] = []
    private var data: [ListItemData] = [] {
        didSet {
            currentTableData = newTableData
            
            print(currentTableData)
            self.table
                .headerTitle { "\(self.currentTableData[$0].first?.section ?? "N/A")"}
                .footerView { _ in UIView() }
                .update { _ in currentTableData }
                .reloadData()
        }
    }
    private var newTableData: [[ListItemData]] {
        data
            .map { ($0.section, $0) }
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
        .sorted(by: { (lhs, rhs) -> Bool in
            return lhs.key < rhs.key
        })
            .map { $0.value }
    }
    
    // MARK: Views
    
    private var table = TableView().configure { $0.separatorStyle = .none }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalStyle.marginBackgroundColor = .white
        globalStyle.textColor = .black
        globalStyle.borderColor = .black
        globalStyle.backgroundColor = .white
        
        Navigate.shared.configure(controller: navigationController)
            .setLeft(barButton: BarButton {
                Button(E.gear.rawValue) {
                    Navigate.shared.go(CellCustomizeViewController(), style: .push)
                }
            })
            .setRight(barButton: BarButton {
                Button(E.plus_sign.rawValue) {
                    Navigate.shared.go(AddViewController(addItemHandler: { [weak self] (newItem) in
                        FLite.create(model: newItem).do { (newItem) in
                            DispatchQueue.main.async {
                                self?.data.append(newItem)
                            }
                        }
                        .catch { print($0.localizedDescription) }
                    }), style: .modal)
                }
            })
        
        table.delegate = self
        
        table.register(cells: [ListItemCell.self])
        
        view.embed {
            table
        }
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.table.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = currentTableData[indexPath.section][indexPath.row]
        
        Navigate.shared.go(DetailViewController(item: data) { [weak self] data  in
            self?.currentTableData[indexPath.section][indexPath.row] = data
            FLite.fetchAll(model: ListItemData.self) { (listItems) in
                DispatchQueue.main.async {
                    self?.data = listItems
                }
            }
        }, style: .push)
    }
}

extension ViewController {
    fileprivate func fetchData() {
        FLite.fetchAll(model: ListItemData.self) { (listItems) in
            DispatchQueue.main.async {
                self.data += listItems
            }
        }
    }
}
