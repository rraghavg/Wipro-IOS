//
//  AppDelegate.swift
//  lab-4b
//
//  Created by Raghav Gupta on 14/11/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        LifecycleLogger.shared.log("AppDelegate: didFinishLaunchingWithOptions")
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        LifecycleLogger.shared.log("AppDelegate: configurationForConnecting")

        let config = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )
        config.delegateClass = SceneDelegate.self
        return config
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LifecycleLogger.shared.log("AppDelegate: applicationWillTerminate")
    }
}
