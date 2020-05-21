//
//  AppDelegate.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootNC: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let vc = LoginController()
        self.rootNC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = self.rootNC
        
        self.window?.makeKeyAndVisible()

        return true
    }
    
    private var wasActive = false
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let vc = self.rootNC?.viewControllers.first as? LoginController, self.wasActive {
            vc.checkTouchID()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.wasActive = true
    }

}

