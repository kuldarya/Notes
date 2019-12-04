//
//  AppDelegate.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataManager.shared.managedContext.automaticallyMergesChangesFromParent = true
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        try? CoreDataManager.shared.saveContext()
    }
}
