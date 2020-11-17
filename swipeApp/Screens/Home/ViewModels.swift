//
//  ViewModels.swift
//  swipeApp
//
//  Created by Damien on 12/11/2020.
//

import Foundation

protocol PhotosProtocol {
    var type: String { get set }
    var url: String { get set }
}

protocol ProfileProtocol {
    var age: Int { get set }
    var birth: String { get set }
    var emojis: [String] { get set }
    var gender: String { get set }
    var location: String { get set }
    var name: String { get set }
    var photos: [PhotosProtocol] { get set }
    var town: String { get set }
    var uid: String { get set }
}

struct PhotosViewModel: PhotosProtocol{
    var type: String
    var url: String
    init(_ raw: PhotosRaw) {
        type = raw.type
        url = raw.url
    }
}

struct ProfileViewModel: ProfileProtocol {
    var age: Int
    var birth: String
    var emojis: [String]
    var gender: String
    var location: String
    var name: String
    var photos: [PhotosProtocol]
    var town: String
    var uid: String

    init(_ raw : ProfileRaw) {
        age = raw.age
        birth = raw.birth
        emojis = raw.emojis
        gender = raw.gender
        location = raw.location
        name = raw.name
        photos =  raw.photos.map {
            PhotosViewModel($0)
        }
        town = raw.town
        uid = raw.uid
    }
}
