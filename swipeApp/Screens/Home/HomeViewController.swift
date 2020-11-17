//
//  HomeViewController.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import UIKit

class HomeViewController: UIViewController, Coordinable, StoryboardInstantiatable, Presentable  {
    var coordinator: Coordinator?
    let stackContainer = SwipeCardContainer()
    var interactor : HomeInteractor?
    var reloadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackContainer)
        configureStackContainer()
        configureNavigationBarButtonItem()
        stackContainer.delegate = self
        interactor?.getData()
    }

    //MARK: - Configurations

   
    func updateViews() {
        stackContainer.reloadData()
    }

    func register(interactor: Interactor) {
        self.interactor =  interactor as? HomeInteractor
    }

    func configureStackContainer() {
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: self.topbarHeight + 5, paddingLeft: 5, paddingBottom: stackContainer.paddingBottomNeeded(), paddingRight: 5, width: 0, height: 0, enableInsets: false)
        self.view.layoutIfNeeded()
    }

    func configureNavigationBarButtonItem() {
        reloadButton = UIButton()
        reloadButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        reloadButton.setImage(UIImage(named: "refresh"), for: UIControl.State())
        navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: reloadButton)
    }

    func startLoading() {
        DispatchQueue.main.async {
            self.reloadButton.infiniteRotate()
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.reloadButton.removeAllAnimations()
        }
    }

    @objc func resetTapped() {
        interactor?.resetTapped()
    }
}

extension HomeViewController: SwipeCardContainerDelegate {

    func didTap(on view: SwipeCardView, model: ProfileProtocol?) {
        self.interactor?.didTap(on: view, model: model)

    }

    func didSwipe(model: ProfileProtocol?, direction: Direction) {
        self.interactor?.didSwipe(model: model, direction: direction)
    }
}

