//
//  HomeCoordinator.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator   {
    var context: Coordinable?
    var navigationController: CoordinableNavivationController?

    required init() {
    }

    func start() {
        context?.registerCoordinator(coordinator: self)
        self.push(self.context)
    }
}
