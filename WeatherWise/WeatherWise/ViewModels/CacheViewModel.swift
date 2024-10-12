//
//  CacheViewModel.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/10/24.
//

import Foundation
import UIKit

class CacheViewModel: ObservableObject {
    @Published var startImage: UIImage? = nil
    @Published var cachedImage: UIImage? = nil
    
    let manager = CacheManager.instance

    init() {
        
    }

    func cacheImage(_ image: UIImage, forKey key: NSString) {
        manager.addImage(image, forKey: key)
    }

    func fetchImage(forKey key: NSString) {
        cachedImage = manager.getImage(forKey: key)
    }

    func removeCachedImage(forKey key: NSString) {
        manager.removeImage(forKey: key)
        cachedImage = nil
    }

    func loadStartImage() {
        if let image = UIImage(named: "startImage") {
            startImage = image
        }
    }
}
