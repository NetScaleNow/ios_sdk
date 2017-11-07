//
//  ImageCache.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 19.05.17.
//
//

import Foundation

class ImageCache {
  static let cache = NSCache<NSString, UIImage>()
}

extension UIImageView {
  func setImageFrom(urlString: String, completion: ((UIImage?) -> Void)? = nil) {
    guard let url = URL(string: urlString) else { return }
    setImageFrom(url: url, completion: completion)
  }
  
  func setImageFrom(url: URL, completion: ((UIImage?) -> Void)? = nil) {
    
    if let cachedImage = ImageCache.cache.object(forKey: url.absoluteString as NSString) {
      image = cachedImage
      completion?(self.image)
    } else {
      requestAndCacheImage(url: url, completion: completion)
    }
  }
  
  private func requestAndCacheImage(url: URL, completion: ((UIImage?) -> Void)? = nil) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      DispatchQueue.main.async {
        if let image = UIImage(data: data) {
          ImageCache.cache.setObject(image, forKey: url.absoluteString as NSString)
          self.image = image
        } else {
          self.image = nil
        }
        completion?(self.image)
      }
      }.resume()
  }
}
