//
//  Coordinator.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import UIKit

protocol Coordinable where Self: UIViewController {
    var coordinator: Coordinator? { get set }
    func registerCoordinator(coordinator: Coordinator?)
}

protocol Coordinator {

    var context: Coordinable? { get set }
    var navigationController: CoordinableNavivationController? { get set }
    func push(_ viewController: Coordinable?)
    func present(_ viewController: Coordinable?)
    init()
    init(from: Coordinable?, screen: Coordinable?)
    func start()
}


extension Coordinable where Self: UIViewController {
    func registerCoordinator(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
}
extension Coordinator {

    func push(_ viewController: Coordinable?) {
        guard let viewController = viewController else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    func present(_ viewController: Coordinable?) {
        guard let viewController = viewController else {
            return
        }
        navigationController?.present(viewController, animated: true, completion: nil)
    }

     init(from: Coordinable?, screen: Coordinable?) {
        self.init()
        context = screen
        if let from = from as? CoordinableNavivationController {
            navigationController = from
        } else {
            navigationController = (from?.navigationController as? CoordinableNavivationController) ??  CoordinableNavivationController()
        }
    }
}

class CoordinableNavivationController: UINavigationController, Coordinable {
    var coordinator: Coordinator?
    func registerCoordinator(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

public protocol StoryboardInstantiatable {
    static var storyboardName: String { get }
    static var viewControllerIdentifier: String? { get }
    static var bundle: Bundle? { get }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    static var storyboardName: String {
        return "Main"
    }

    static var viewControllerIdentifier: String? {
        return String(describing: self)

    }

    static var bundle: Bundle? {
        return nil
    }

    static func instantiate() -> Self {
        let loadViewController = { () -> UIViewController? in
            let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
            if let viewControllerIdentifier = viewControllerIdentifier {
                return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
            } else {
                return storyboard.instantiateInitialViewController()
            }
        }

        guard let viewController = loadViewController() as? Self else {
            fatalError()
        }
        return viewController
    }
}





