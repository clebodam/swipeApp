//
//  SwipeCardContainer.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import UIKit

protocol SwipeCardContainerDelegate: class {
    func didSwipe(model:Profile?, direction: Direction)
    func didTap(on view: SwipeCardView, model: Profile?)
}

class SwipeCardContainer: UIView, SwipeCardsDelegate {

    //MARK: - Properties

    var cardsNumber: Int = 0
    var cardsToBeShown: Int = 20
    var cardViews : [SwipeCardView] = []
    var remainingCardsNumber: Int = 0
    let horizontalInset: CGFloat = 4.0
    let verticalInset: CGFloat = 4.0
    var visibleCards: [SwipeCardView] {
        return subviews.compactMap { $0 as? SwipeCardView
        }
    }
    weak var delegate: SwipeCardContainerDelegate?
    weak var dataSource: SwipeCardsDataSource?

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        reset()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        cardsNumber = datasource.cardsNumber()
        remainingCardsNumber = cardsNumber
        for i in 0..<min(cardsNumber,cardsToBeShown) {
            createCardView(cardView: datasource.card(at: i), atIndex: i )
        }
    }

    //MARK: - Configurations

    private func createCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        createCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCardsNumber -= 1
    }

    func createCardFrame(index: Int, cardView: SwipeCardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = CGFloat(index) * self.verticalInset
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        cardView.frame = cardViewFrame
    }

    private func reset() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }

    func swipeDidEnd(on view: SwipeCardView, direction: Direction, model: Profile?) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        if remainingCardsNumber > 0 {
            let newIndex = datasource.cardsNumber() - remainingCardsNumber
            createCardView(cardView: datasource.card(at: newIndex), atIndex: newIndex)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                cardView.center = self.center
                  self.createCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }

        }else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.createCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
        self.delegate?.didSwipe(model: model, direction: direction)
    }

    func didTap(on view: SwipeCardView, model: Profile?) {
        self.delegate?.didTap(on: view, model: model)
    }
}

