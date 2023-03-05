//
//  AppDelegate.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit
import Nuke
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialHomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        initialHomeVC.viewModel = HomeViewModel(catService: ServiceContainer.shared.catService)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: initialHomeVC)
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

