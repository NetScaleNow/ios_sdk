//
//  AppDelegate.swift
//  NetScaleNow
//
//  Created by jstubenrauch on 06/27/2017.
//  Copyright (c) 2017 jstubenrauch. All rights reserved.
//

import UIKit
import NetScaleNow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Config.apiKey = "ios-sdk-123456789"
        Config.apiSecret = "123456789"
        
        return true
    }
}

