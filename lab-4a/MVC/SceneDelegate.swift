//
//  SceneDelegate.swift
//  lab-4a (MVC)
//
//  Created by Raghav Gupta on 12/11/26.
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
        window.rootViewController = TaskListViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
