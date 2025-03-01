//
//  ImageCache.swift
//  Test
//
//  Created by Rina Mitina on 01.03.2025.
//

import Foundation
import UIKit

/// Класс для кэширования изображений на основе NSCache.
final class ImageCache {
  
  static let shared = ImageCache()
  private let cache = NSCache<NSString, UIImage>()
    
  func getImage(for url: String) -> UIImage? {
    cache.object(forKey: url as NSString)
  }
    
  func setImage(_ image: UIImage, for url: String) {
    cache.setObject(image, forKey: url as NSString)
  }
  
  func removeImage(for url: String) {
    cache.removeObject(forKey: url as NSString)
  }
}

