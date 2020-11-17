//
//  Profile.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation


struct NetWorkServiceResponse: Codable{
    var data: [ProfileRaw]
}

struct ProfileRaw: Codable {
    var age: Int
    var birth: String
    var emojis: [String]
    var gender: String
    var location: String
    var name: String
    var photos: [PhotosRaw]
    var town: String
    var uid: String
}

struct PhotosRaw: Codable{
    var type: String
    var url: String
}







