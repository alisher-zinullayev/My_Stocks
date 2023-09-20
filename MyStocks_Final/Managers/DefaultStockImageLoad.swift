//
//  DefaultStockImageLoad.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 20.09.2023.
//

import UIKit

protocol ImageLoadProtocol: AnyObject {
    func fetchImage(url: URL) async throws -> UIImage?
}

let imageCache = NSCache<AnyObject, AnyObject>()

final class DefaultStockImageLoad: UIImageView, ImageLoadProtocol {
    func fetchImage(url: URL) async throws -> UIImage? {
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            return imageFromCache
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = image
                }
                
                return image
            }
        } catch {
            print("couldn't load image from url: \(url), error: \(error)")
        }
        
        return nil
    }


}
