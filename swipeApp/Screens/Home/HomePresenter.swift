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


    var viewModelData: [Profile]?

    func reloadData() {
        DispatchQueue.main.async {
            self.homeScreen?.stackContainer.reloadData()
        }
    }
}

extension HomePresenter : SwipeCardsDataSource {

    func cardsNumber() -> Int {
        return viewModelData?.count ?? 0
    }

    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData?[index]
        return card
    }
}
