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

var sortOption = SortOption(sectionDataOption: .section,
                            sectionSortMethod: .alphabetical(ascending: true),
                            dataOption: .title,
                            sortMethod: .alphabetical(ascending: false))
class ViewController: UIViewController {
    // MARK: Data
    private(set) var currentTableData: [[ListItemData]] = []
    private var data: [ListItemData] = [] {
        didSet {
            reload()
        }
    }
    private var newTableData: [[ListItemData]] {
        data.sorted(by: sortOption)
    }
    
    private func reload() {
        currentTableData = newTableData
        
        print(currentTableData)
        self.table
            .headerTitle { "\( self.currentTableData[$0].first.map { data in sortOption.sectionDataOption.value(forData: data) } ?? "")" }
            .footerView { _ in UIView() }
            .update { _ in currentTableData }
            .reloadData()
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
        .setRight(barButtons: [
            BarButton {
                Button("Add", titleColor: view.tintColor) { [weak self] in
                    Navigate.shared.go(AddViewController(addItemHandler: { (newItem) in

                        print("Adding VC: \(newItem.title)")
                        FLite.create(model: newItem, onError: { (error) in
                            print("FLITE: \(error)")
                        }) { (newItem) in
                             print("Adding Create: \(newItem.title)")
                                                       DispatchQueue.main.async {
                                                           print("Adding Append: \(newItem.title)")
                                                           self?.data.append(newItem)
                                                       }
                        }
                    }), style: .modal)
                }
            },
            BarButton {
                Button("Sort", titleColor: view.tintColor) { [weak self] in
                    Navigate.shared.go(UIViewController {
                            UIView(backgroundColor: .brown) {
                                Button("Tag Count Dec") {
                                    sortOption = SortOption(sectionDataOption: .tags,
                                                            sectionSortMethod: .alphabetical(ascending: true),
                                                            dataOption: .title,
                                                            sortMethod: .alphabetical(ascending: true))
                                    self?.reload()
                                }
                            }
                        }, style: .modal)
                }
            }
        ])
        
        table.delegate = self
        
        table.register(cells: [ListItemCell.self])
            .canEditRowAtIndexPath { _ in true }
            .editingStyleForRowAtIndexPath { _ in .delete }
            .commitEditingStyleForRowAtIndexPath { [weak self] (style, path) in
                guard let self = self else {
                    return
                }
                
                
                let element = self.currentTableData[path.section][path.row]
                FLite.connection(withHandler: { (connection) in
                    element.delete(on: connection).catch {
                        print("\($0)")
                    }
                }) {
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
