//
//  AppCoordinator.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation
import UIKit
class AppCoordinator: Coordinator {
   
    var context: Coordinable?
    var navigationController: CoordinableNavivationController?

    required init() {
    }

    func start() {
        let homeCoordinator = HomeCoordinator(from: navigationController, screen: context)
        if let context = context as? HomeViewController {
            let presenter = HomePresenter()
            presenter.register(presentable: context)
            let interactor = HomeInteractor()
            interactor.register(presenter: presenter)
            interactor.worker = NetWorkManager()
            context.register(interactor: interactor)
            context.registerCoordinator(coordinator: homeCoordinator)
        }
        homeCoordinator.start()
    }

    func configureAndStartFromWindow( _ window: UIWindow) {
        window.setup(navigationController)
        start()
    }
}

public extension UIWindow {

    func setup(_ rootVC: UIViewController?) {
        self.rootViewController = rootVC
        self.makeKeyAndVisible()
    }
}
