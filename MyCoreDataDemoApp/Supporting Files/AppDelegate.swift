//
//  AppDelegate.swift
//  MyCoreDataDemoApp
//
//  Created by Vladislav on 30.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}

