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
        getData()
    }

    func didSwipe(model: ProfileProtocol?, direction: Direction) {
        print(  "swipe \(direction) \(String(describing: model))")
        guard let model = model else {
            return
        }
        worker?.postLike(model.uid, direction == .right) { result in
            switch result {
            case .success( _):
                self.didSwipeModel(model)
                print(" post OK")
            case .failure( _):
                print(" post NOK")
            }
        }
    }

    func didTap(on view: SwipeCardView, model: ProfileProtocol?) {
        print(  "tap \(String(describing: model))")
    }

    func getData() {
        self.homePresenter?.startLoading()
        worker?.getData(completion: { profiles, error in
            let model = profiles.map {
                ProfileViewModel($0) as ProfileProtocol
            }
            self.updateModel(model)
            self.homePresenter?.stopLoading()
        })
    }

    func updateModel(_ model: [ProfileProtocol]) {
        self.homePresenter?.viewModelData  = model
        self.homePresenter?.reloadData()
    }

    func didSwipeModel(_ model: ProfileProtocol) {
        self.homePresenter?.didSwipeModel(model)

    }
}
