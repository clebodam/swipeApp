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

    private let PROFILES_HOST =
        "test.yellw.co"
    private let GET_PROFILE_PATH =
        "/list"
    private let LIKE_PATH =
        "/like"
    private let DISLIKE_PATH =
        "/dislike"


    private var _currentTask: URLSessionDataTask?

    init() {
        sessionCfg = URLSessionConfiguration.default
        sessionCfg.timeoutIntervalForRequest = 10.0
        session = URLSession(configuration: sessionCfg)
    }

    internal  func get( route: String, callback: ((Result<[Profile], Error>) -> Void)?) {
        if let task = _currentTask { task.cancel() }
        if let url = URL(string: route) {

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            _currentTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let e = error {
                    callback?(Result.failure(e))
                }else {
                    if let r = response as? HTTPURLResponse {
                        if  r.statusCode == 200{
                            if let data = data {
                                do {
                                    var result = [Profile]()
                                    if let json = self.convertToDictionary(data: data) {
                                        let profilesJson: AnyObject? =  json["data"] as AnyObject
                                        if let  profilesData =  self.jsonToData(json: profilesJson) {
                                            let decoder = JSONDecoder()
                                            result = try decoder.decode([Profile].self, from: profilesData)
                                        }
                                        callback?(Result.success(result))
                                    }

                                } catch {
                                    print(error)
                                    callback?(Result.failure(NetworkError.serialization))
                                }
                            } else {
                                callback?(Result.failure(NetworkError.noData))
                            }
                        }else {
                            callback?(Result.failure(NetworkError.invalidStatusCode))
                        }
                    }else {
                        callback?(Result.failure(NetworkError.invalidResponse))
                    }
                }
            })

            _currentTask?.resume()

        }else {
            callback?(Result.failure(NetworkError.badUrl))
        }
    }

    public func getProfiles(callback: ((Result<[Profile], Error>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = PROFILES_HOST
        urlComponents.path = GET_PROFILE_PATH
        guard let url = urlComponents.url?.absoluteString else {
            return
        }
        self.get( route: url, callback: callback )
    }


    func postLike(_ uid: String, _ like:Bool,  callback: ((Result<String, Error>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = PROFILES_HOST
        urlComponents.path = like ? LIKE_PATH : DISLIKE_PATH
        guard let url = urlComponents.url else {
            return
        }
        if let task = _currentTask { task.cancel() }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = ["uid": uid]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        _currentTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let e = error {
                callback?(Result.failure(e))
            }else {
                if let r = response as? HTTPURLResponse {
                    if  r.statusCode == 200{
                        if let data = data {
                            do {
                                let result = String(decoding: data, as: UTF8.self)
                                callback?(Result.success(result))
                            }

                        } else {
                            callback?(Result.failure(NetworkError.noData))
                        }
                    } else {
                        callback?(Result.failure(NetworkError.invalidStatusCode))
                    }
                } else {
                    callback?(Result.failure(NetworkError.invalidResponse))
                }
            }
        }
        )
        _currentTask?.resume()
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


    func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func jsonToData(json: AnyObject?) -> Data?{
        guard let json = json else {
            return nil
        }
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
}



