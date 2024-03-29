//
//  AppDelegate.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import IQKeyboardManager
import Nuke
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true

        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewModel = HomeViewModel(catService: ServiceContainer.shared.catService)
        let initialHomeVC = storyboard.instantiateViewController(identifier: "HomeViewController") { coder in
            return HomeViewController(coder: coder, viewModel: viewModel)
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: initialHomeVC)
        window?.makeKeyAndVisible()

        return true
    }
}
