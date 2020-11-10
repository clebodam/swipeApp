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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        view.addSubview(stackContainer)
        configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        configureNavigationBarButtonItem()
        stackContainer.delegate = self
        stackContainer.reloadData()
        interactor?.getData()
    }

    //MARK: - Configurations

    func updateViews() {
    }

    func register(interactor: Interactor) {
        self.interactor =  interactor as? HomeInteractor
    }

    func configureStackContainer() {
        stackContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: self.topbarHeight + 5, paddingLeft: 5, paddingBottom: 50, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        self.view.layoutIfNeeded()
    }

    func configureNavigationBarButtonItem() {
        let button1 = UIButton()
        button1.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        button1.setImage(UIImage(named: "refresh"), for: UIControl.State())
        navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: button1)
    }


    @objc func resetTapped() {
        interactor?.resetTapped()
    }

    func goToDetails() {
        if let homeCoordinator = coordinator as? HomeCoordinator {
            //homeCoordinator.goToDetails()
        }
    }
}



extension HomeViewController: SwipeCardContainerDelegate {

    func didTap(on view: SwipeCardView, model: Profile?) {
        self.interactor?.didTap(on: view, model: model)
        goToDetails()

    }

    func didSwipe(model: Profile?, direction: Direction) {
        self.interactor?.didSwipe(model: model, direction: direction)
    }
}

