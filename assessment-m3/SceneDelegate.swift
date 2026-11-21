//
//  SceneDelegate.swift
//  assessment-m3
//
//  Created by Raghav Gupta
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        // Tab 1 — Profile Form (R1: validation + Auto Layout)
        let formVC = ProfileFormViewController()
        formVC.tabBarItem = UITabBarItem(title: "Register",
                                         image: UIImage(systemName: "person.badge.plus"),
                                         tag: 0)
        let formNav = UINavigationController(rootViewController: formVC)

        // Tab 2 — Post Directory (R2, R3, R4: JSON list + states + navigation)
        let listVC = PostListViewController()
        listVC.tabBarItem = UITabBarItem(title: "Directory",
                                         image: UIImage(systemName: "list.bullet.rectangle"),
                                         tag: 1)
        let listNav = UINavigationController(rootViewController: listVC)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [formNav, listNav]

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        self.window = window
    }
}
