//
//  Presenter.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation

protocol Presenter: class  {

    var presentable: Presentable? {get set}
    func register(presentable: Presentable)
}

protocol Presentable: class {
    func updateViews()
}


