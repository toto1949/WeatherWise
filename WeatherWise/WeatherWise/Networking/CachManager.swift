//
//  CachManager.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/10/24.
//

import Foundation
import UIKit

class CacheManager {
    static let instance = CacheManager()
    private init() {}

    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 1000
        cache.totalCostLimit = 1024 * 1024 * 1000
        return cache
    }()

    func addImage(_ image: UIImage, forKey key: NSString) {
        imageCache.setObject(image, forKey: key)
    }

    func getImage(forKey key: NSString) -> UIImage? {
        return imageCache.object(forKey: key)
    }

    func removeImage(forKey key: NSString) {
        imageCache.removeObject(forKey: key)
    }
}
