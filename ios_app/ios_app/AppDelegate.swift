//
//  AppDelegate.swift
//  ios_app
//
//  Created by Chandan on 14/10/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        juceMessageManagerInit()
        juceEnableLogs()
        return true
    }
}
