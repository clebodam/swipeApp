//
//  SwipeCardView.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import UIKit

enum Direction: Int {
    case right
    case left
}
protocol SwipeCardsDataSource: class  {

    func cardsNumber() -> Int
    func cardInfo (at index: Int) -> ProfileProtocol?


}

protocol SwipeCardsDelegate: class {
    func swipeDidEnd(on view: SwipeCardView, direction: Direction, model: ProfileProtocol?)
    func didTap(on view: SwipeCardView, model: ProfileProtocol?)
}

class SwipeCardView : UIView {

    //MARK: - Properties
    var swipeView = UIView()
    var shadowView = UIView()
    var imageView = UIImageView()
    var emojilabel = UILabel()
    var locationlabel = UILabel()
    var nameLabel = UILabel()
    weak var delegate : SwipeCardsDelegate?
    var stateImage = UIImageView()
    var imageIndex = 0
    var paging = UIPageControl()
    var profileViewModel : ProfileProtocol? {
        didSet {
            emojilabel.text = "   \(profileViewModel?.emojis.joined(separator: " ") ?? "")"
            locationlabel.text = "   \(profileViewModel?.location.uppercased() ?? ""), \(profileViewModel?.town ?? "")"
            let imageUrl = profileViewModel?.photos.first?.url ?? ""
            _ =  imageView.loadImageUsingCache(withUrl: imageUrl)
            nameLabel.text = "   \(profileViewModel?.name.uppercased() ?? ""), \(String(profileViewModel?.age ?? 0) )"
            paging.numberOfPages = profileViewModel?.photos.count ?? 0
            paging.isHidden =  paging.numberOfPages < 2
        }
    }

    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        setupShadow()
        setupSwipeView()
        setupImage()
        setupEmojiLabel()
        setupLocationLabel()
        setupNameLabel()
        setupState()
        setupPaging()
        addPanGestureOnCards()
        configureTapGesture()
        reset()
    }

    func reset() {
        self.frame = .zero
        self.swipeView.frame = .zero
        self.shadowView.frame = .zero
        self.transform = .identity
        self.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Configuration

    func setupState() {
        stateImage.backgroundColor = .clear
        stateImage.contentMode = .scaleAspectFit
        stateImage.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(stateImage)
        stateImage.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        stateImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        stateImage.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        stateImage.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    func setupShadow() {
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 4.0
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

    func setupSwipeView() {
        swipeView.layer.cornerRadius = 15
        swipeView.clipsToBounds = true
        shadowView.addSubview(swipeView)
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        swipeView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        swipeView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        swipeView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }

    func setupEmojiLabel() {
        swipeView.addSubview(emojilabel)
        emojilabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        emojilabel.textColor = .white
        emojilabel.textAlignment = .left
        emojilabel.font = UIFont.systemFont(ofSize: 25)
        emojilabel.translatesAutoresizingMaskIntoConstraints = false
        emojilabel.anchor(top: nil, left: swipeView.leftAnchor, bottom: swipeView.bottomAnchor, right: swipeView.rightAnchor, paddingTop:0 , paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40, enableInsets: false)

    }
    func setupLocationLabel() {
        swipeView.addSubview(locationlabel)
        locationlabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        locationlabel.textColor = .white
        locationlabel.textAlignment = .left
        locationlabel.font = UIFont.systemFont(ofSize: 18)
        locationlabel.translatesAutoresizingMaskIntoConstraints = false
        locationlabel.anchor(top: nil, left: swipeView.leftAnchor, bottom: emojilabel.topAnchor, right: swipeView.rightAnchor, paddingTop:0 , paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40, enableInsets: false)
    }

    func setupNameLabel() {
        swipeView.addSubview(nameLabel)
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.anchor(top: nil, left: swipeView.leftAnchor, bottom: locationlabel.topAnchor, right: swipeView.rightAnchor, paddingTop:0 , paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40, enableInsets: false)

    }

    func setupPaging() {
        swipeView.addSubview(paging)
        paging.currentPageIndicatorTintColor = .white
        paging.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        paging.translatesAutoresizingMaskIntoConstraints = false
        paging.anchor(top: swipeView.topAnchor, left: swipeView.leftAnchor, bottom: nil, right: swipeView.rightAnchor, paddingTop:0 , paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40, enableInsets: false)
    }

    func setupImage() {
        swipeView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.anchor(top: swipeView.topAnchor, left: swipeView.leftAnchor, bottom: swipeView.bottomAnchor, right: swipeView.rightAnchor, paddingTop:0 , paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)

    }

    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }


    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }



    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        guard let card = sender.view as? SwipeCardView else {
            return
        }
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        switch sender.state {
        case .ended:
            stateImage.image = nil
            stateImage.isHidden = true
            if (card.center.x) >  4 * UIScreen.main.bounds.width / 5 {
                delegate?.swipeDidEnd(on: card, direction: .right, model: profileViewModel)
                return
            }else if card.center.x < UIScreen.main.bounds.width / 5 {
                delegate?.swipeDidEnd(on: card, direction: .left, model: profileViewModel)
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            stateImage.isHidden = false
            let rotation = tan(point.x / (self.frame.width * 2.0))
            print(card.center.x)
            if (card.center.x) > self.frame.width / 2 {
                print("Like")
                stateImage.image = UIImage(named: "buttonLike")
            } else if card.center.x < self.frame.width / 2 {
                print("Pass")
                stateImage.image = UIImage(named: "buttonPass")
            }
            else {
                stateImage.image = nil
                stateImage.isHidden = true
            }
            card.transform = CGAffineTransform(rotationAngle: rotation)
        default:
            break
        }
    }

    @objc func handleTapGesture(sender: UITapGestureRecognizer){
        let card = sender.view as! SwipeCardView
        delegate?.didTap(on: card, model: profileViewModel)
        guard let photos = profileViewModel?.photos else {
            return
        }
        if imageIndex <  photos.count - 1  {
            imageIndex += 1
        } else {
            imageIndex = 0
        }
        paging.currentPage = imageIndex
        let imageUrl = photos[imageIndex].url
        _ =  imageView.loadImageUsingCache(withUrl: imageUrl)
    }
}

