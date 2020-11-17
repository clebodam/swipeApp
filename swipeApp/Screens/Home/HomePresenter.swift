//
//  HomePresenter.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation
import UIKit

class HomePresenter : Presenter {
   weak  var presentable: Presentable?

    func register(presentable: Presentable) {
        self.presentable = presentable
        homeScreen?.stackContainer.dataSource = self
    }

    var homeScreen: HomeViewController? {
        get  {
            return self.presentable as? HomeViewController
        }
    }

    var viewModelData: [ProfileProtocol]?

    func reloadData() {
        DispatchQueue.main.async {
            self.homeScreen?.updateViews()
        }
    }

    func didSwipeModel(_ model: ProfileProtocol) {
        viewModelData =  viewModelData?.filter {
            $0.uid != model.uid
        }
      //  reloadData()
    }

    func startLoading() {
        self.homeScreen?.startLoading()
    }

    func stopLoading() {
        self.homeScreen?.stopLoading()
    }

    func profileForIndex(_ index : Int) -> ProfileProtocol? {
        return viewModelData?[index]
    }
}

extension HomePresenter : SwipeCardsDataSource {

    func cardsNumber() -> Int {
        return viewModelData?.count ?? 0
    }

    func cardInfo (at index: Int) -> ProfileProtocol? {
        return viewModelData?[index]
    }

}
