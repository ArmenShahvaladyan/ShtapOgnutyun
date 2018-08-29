//
//  UIImageView+Extension.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 6/4/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, placeholderImage img:UIImage, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping () -> ()) {
        contentMode = mode
        self.image = img
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                completion()
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, placeholderImage img: UIImage, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping () -> ()) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, placeholderImage: img, completion: completion)
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
