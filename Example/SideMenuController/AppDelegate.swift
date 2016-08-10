//
//  AppDelegate.swift
//  SideMenuController
//
//  Created by Ryan Fitzgerald on 08/10/2016.
//  Copyright (c) 2016 Ryan Fitzgerald. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      window = UIWindow(frame: UIScreen.mainScreen().bounds)

      if let win = window {
        let nav = UINavigationController(rootViewController: ViewController() )
        win.rootViewController = nav
        win.makeKeyAndVisible()
      }

      return true
    }


}
