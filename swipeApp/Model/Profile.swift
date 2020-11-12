//
//  Profile.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation


struct NetWorkServiceResponse: Codable{
    var data: [Profile]
}

struct Profile: Codable{
    var age: Int
    var birth: String
    var emojis: [String]
    var gender: String
    var location: String
    var name: String
    var photos: [Photos]
    var town: String
    var uid: String
 
}

struct Photos: Codable{
    var type: String
    var url: String
}
