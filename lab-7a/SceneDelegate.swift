//
//  SceneDelegate.swift
//  lab-7a
//
//  Created by Raghav Gupta.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let formVC = ProfileFormViewController()
        let navController = UINavigationController(rootViewController: formVC)

        navController.navigationBar.prefersLargeTitles = true

        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
