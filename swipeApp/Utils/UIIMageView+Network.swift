//
//  UIIMageView+Network.swift
//  swipeApp
//
//  Created by Damien on 10/11/2020.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) -> URLSessionDataTask? {

        self.image = UIImage(named:"image-not-found")
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return nil
        }
        // if not, download image from url
        guard let url = URL(string: urlString) else {
            return nil
        }

        let  task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        })

        task.resume()
        return task
    }


}
