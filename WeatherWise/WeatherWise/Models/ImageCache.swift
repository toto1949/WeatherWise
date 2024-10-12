//
//  ImageCache.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/9/24.
//

import SwiftUI

class ImageCache: ObservableObject {
    static let shared = ImageCache()
    
    private var cache: [String: UIImage] = [:]

    func setObject(_ image: UIImage, forKey key: NSString) {
        cache[key as String] = image
    }

    func object(forKey key: NSString) -> UIImage? {
        return cache[key as String]
    }
}
