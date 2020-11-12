//
//  NetworkService.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

//
//  NetworkService.swift
//  driveQuantTest
//
//  Created by Damien on 03/11/2020.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidStatusCode
    case invalidResponse
    case noData
    case serialization
}
typealias CompletionBlock = ([Profile], NetworkError?) -> ()
protocol NetWorkManagerProtocol {
    func getData(completion: @escaping CompletionBlock)
    func postLike(_ uid: String, _ like:Bool,  callback: ((Result<String, Error>) -> Void)?) 
}

class NetWorkManager: NetWorkManagerProtocol {

    var session: URLSession
    var sessionCfg: URLSessionConfiguration
    private let PROFILES_HOST = "test.yellw.co"
    private let GET_PROFILE_PATH = "/list"
    private let LIKE_PATH = "/like"
    private let DISLIKE_PATH = "/dislike"
    private var currentTask: URLSessionDataTask?

    init() {
        sessionCfg = URLSessionConfiguration.default
        sessionCfg.timeoutIntervalForRequest = 10.0
        session = URLSession(configuration: sessionCfg)
    }

    internal  func get( route: String?, callback: ((Result<[Profile], Error>) -> Void)?) {
        if let task = currentTask { task.cancel() }
        guard let url = URL(string: route ?? "") else {
            callback?(Result.failure(NetworkError.badUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        currentTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let e = error {
                callback?(Result.failure(e))
                return
            }
            guard let response = response as? HTTPURLResponse  else {
                callback?(Result.failure(NetworkError.invalidResponse))
                return
            }
            if response.statusCode == 200 {
                guard let data = data  else {
                    callback?(Result.failure(NetworkError.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let responseObject  = try decoder.decode(NetWorkServiceResponse.self, from: data)
                    let result: [Profile]  = responseObject.data
                    callback?(Result.success(result))
                } catch {
                    print(error)
                    callback?(Result.failure(NetworkError.serialization))
                }
            } else {
                callback?(Result.failure(NetworkError.invalidStatusCode))
            }
        })
        currentTask?.resume()
    }

    public func getProfiles(callback: ((Result<[Profile], Error>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = PROFILES_HOST
        urlComponents.path = GET_PROFILE_PATH
        self.get( route: urlComponents.url?.absoluteString, callback: callback )
    }


    public func postLike(_ uid: String, _ like:Bool,  callback: ((Result<String, Error>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = PROFILES_HOST
        urlComponents.path = like ? LIKE_PATH : DISLIKE_PATH
        guard let url = urlComponents.url else {
            callback?(Result.failure(NetworkError.badUrl))
            return
        }
        if let task = currentTask { task.cancel() }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = ["uid": uid]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        currentTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                callback?(Result.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse  else {
                callback?(Result.failure(NetworkError.invalidResponse))
                return
            }
            if response.statusCode == 200 {
                guard let data = data  else {
                    callback?(Result.failure(NetworkError.noData))
                    return
                }
                do {
                    let result = String(decoding: data, as: UTF8.self)
                    callback?(Result.success(result))
                    }
            } else {
                callback?(Result.failure(NetworkError.invalidStatusCode))
            }
        })
        currentTask?.resume()
    }

    public  func getData(completion: @escaping CompletionBlock){

        var profiles = [Profile]()
        var netWorkError: NetworkError? = nil
        getProfiles { (result) in
            switch result {
            case .success(let response):
                profiles = response
            case .failure(let error):
                netWorkError = error as? NetworkError
                print("fetch drivers fail from intenet")
            }
            completion(profiles, netWorkError)
        }
    }
}



