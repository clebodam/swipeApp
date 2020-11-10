//
//  Interactor.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation

protocol Interactor: class {
    var presenter: Presenter? { get set }
    func register(presenter: Presenter)
}
