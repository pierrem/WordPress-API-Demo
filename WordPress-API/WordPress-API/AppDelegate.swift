//
//  AppDelegate.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

// 6 sept 2015 Swift 2 compatibility

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        return true
    }
    
}

