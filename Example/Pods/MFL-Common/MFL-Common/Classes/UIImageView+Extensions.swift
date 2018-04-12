//
//  UIImageView+Extensions.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/10/2017.
//

import UIKit

public extension UIImageView {
    
    public func mfl_setImage(withUrl url: URL?) {
        
        if url != nil {
            af_setImage(withURL: url!,
                        imageTransition: .crossDissolve(0.2))
        } else {
            image = nil
        }
        
    }
    
    public func mfl_setImage(withUrlString urlString: String?) {
        if let urlString = urlString {
            mfl_setImage(withUrl: URL(string: urlString))
        } else {
            mfl_setImage(withUrl: nil)
        }
    }
    
    public func mfl_setImage(withPrefetchedImageUrl urlString: String) {
        guard let imageData = ImageDownloader.localImageData(for: urlString) else { return }
        image = UIImage(data: imageData)
    }
}
