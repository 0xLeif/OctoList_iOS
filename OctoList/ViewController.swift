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

class ViewController: UIViewController {
    // MARK: Data
    private(set) var currentTableData: [[ListItemData]] = []
    private var data: [ListItemData] = [] {
        didSet {
            currentTableData = newTableData
            
            print(currentTableData)
            self.table
                .headerTitle { "\(self.currentTableData[$0].first?.section ?? "")" }
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
        
        Navigate.shared.configure(controller: navigationController)
        .set(title: "OctoList")
            .setLeft(barButton: BarButton {
                Button("Settings", titleColor: view.tintColor) {
                    Navigate.shared.go(SettingsViewController(), style: .push)
                }
            })
            .setRight(barButton: BarButton {
                Button("Add", titleColor: view.tintColor) {
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
            .canEditRowAtIndexPath { _ in true }
            .editingStyleForRowAtIndexPath { _ in .delete }
            .commitEditingStyleForRowAtIndexPath { [weak self] (style, path) in
                guard let self = self else {
                    return
                }
                
                
                let element = self.currentTableData[path.section][path.row]
                
                FLite.connection.then { (connection) in
                    element.delete(on: connection)
                }.catch {
                    print("\($0)")
                }.whenComplete {
                    Navigate.shared.destroyToast()
                }
                
                self.data.removeAll(where: { $0.id == element.id })
        }
        
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
