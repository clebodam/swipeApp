//
//  HomeInteractor.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation

class HomeInteractor: Interactor {
    var presenter: Presenter?
    var worker: NetWorkManagerProtocol?
    func register(presenter: Presenter) {
        self.presenter = presenter
    }

    var homePresenter : HomePresenter? {
        get {
            return presenter as? HomePresenter
        }
    }

    func resetTapped() {
        homePresenter?.reloadData()
    }

    func didSwipe(model: Profile?, direction: Direction) {
        print(  "swipe \(direction) \(String(describing: model))")
        guard  let uid = model?.uid else {
            return
        }
        worker?.postLike(uid, direction == .right) { result in

            switch result {
            case .success( _):
                print(" post OK")
            case .failure( _):
                print(" post NOK")
            }
        }
    }

    func didTap(on view: SwipeCardView, model: Profile?) {
        print(  "tap \(String(describing: model))")
    }

    func getData() {
        worker?.getData(completion: { profiles, error in
            self.homePresenter?.viewModelData = profiles
            self.homePresenter?.reloadData()

        })
    }


}
