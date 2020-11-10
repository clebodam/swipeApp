//
//  AppDelegate.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            appCoordinator = AppCoordinator( from: nil , screen : HomeViewController.instantiate())
            appCoordinator?.configureAndStartFromWindow(window)
        }
        return true
    }

}

