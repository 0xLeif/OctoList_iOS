//
//  AppDelegate.swift
//  OctoList
//
//  Created by Zach Eriksen on 4/25/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import FLite
import SwiftUIKit

var globalStyle = SUIKStyle()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FLite.storage = .file(path: "\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")/default.sqlite")
        
        FLite.prepare(model: ListItemData.self).whenComplete {
            print("FLite Prepared: ListItemData")
        }
        
        FLite.prepare(model: SUIKStyle.self).whenComplete {
            print("FLite Prepared: SUIKStyle")
        }
        
        FLite.create(model: globalStyle).catch { print($0) }.whenComplete {
            print("Added :\(globalStyle)")
        }
        
        FLite.fetchAll(model: SUIKStyle.self) { (styles) in
            styles.first.map { print("Found Style: \($0)") }
            
            globalStyle = styles.first ?? SUIKStyle()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

