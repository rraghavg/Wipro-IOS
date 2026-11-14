//
//  SceneDelegate.swift
//  lab-4b
//
//  Created by Raghav Gupta on 14/11/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        LifecycleLogger.shared.log("SceneDelegate: willConnectToSession")

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let firstVC = FirstViewController()
        let navController = UINavigationController(rootViewController: firstVC)

        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        LifecycleLogger.shared.log("SceneDelegate: sceneWillEnterForeground")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        LifecycleLogger.shared.log("SceneDelegate: sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        LifecycleLogger.shared.log("SceneDelegate: sceneWillResignActive")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LifecycleLogger.shared.log("SceneDelegate: sceneDidEnterBackground (saving draft)")

        // extension: save draft when app enters background
        NotificationCenter.default.post(name: NSNotification.Name("SaveDraftNotification"), object: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        LifecycleLogger.shared.log("SceneDelegate: sceneDidDisconnect")
    }
}
