//
//  UIImage+Extensions.swift
//  Pods
//
//  Created by Alex Miculescu on 31/08/2017.
//
//

import UIKit
import Photos

public extension UIImage {
    
    convenience init?(named name: String, bundle: Bundle?) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
    
    static func template(named name: String, in bundle: Bundle?) -> UIImage? {
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        return image?.withRenderingMode(.alwaysTemplate)
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    func thumbnail() -> UIImage {
        let defaultThumbnailWidth = CGFloat(187.0)
        let aspectRatio = self.size.height / self.size.width
        let thumbSize = CGSize(width: defaultThumbnailWidth, height: defaultThumbnailWidth * aspectRatio)
        
        UIGraphicsBeginImageContext(thumbSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: thumbSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    public convenience init?(withPrefetchedImageUrl urlString: String ) {
        guard let imageData = ImageDownloader.localImageData(for: urlString) else { return nil }
        self.init(data: imageData)
    }
}

public extension UIImageView {
    
    func setImageTemplate(named name: String, in bundle: Bundle?, color: UIColor?) {
        self.image = UIImage.template(named: name, in: bundle)
        self.tintColor = color
    }
}

public extension PHAsset {
    
    func videoData() -> Data? {
        let manager = PHImageManager.default()
        let options = PHVideoRequestOptions()
        var videoData : Data? = nil
        options.isNetworkAccessAllowed = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        
        
        
        manager.requestAVAsset(forVideo: self, options: nil, resultHandler: { (avasset, audio, info) in
            if let avassetURL = avasset as? AVURLAsset {
                guard let video = try? Data(contentsOf: avassetURL.url) else {
                    return
                }
                
                videoData = video
                semaphore.signal()
            }
        })
        
        
        
        
//        manager.requestAVAsset(forVideo: self,
//                               options: options)
//        { (avAsset: AVAsset?, _, _) in
//            url = (avAsset as? AVURLAsset)?.url
//            semaphore.signal()
//        }
        
        semaphore.wait()
    
        return videoData
    }
    
    func thumbnail() -> UIImage {
        let defaultThumbnailWidth = CGFloat(187.0)
        let aspectRatio = CGFloat(pixelHeight) / CGFloat(pixelWidth)
        let thumbSize = CGSize(width: defaultThumbnailWidth, height: defaultThumbnailWidth * aspectRatio)
        
        return image(size: thumbSize)
    }
    
    func image() -> UIImage {
        return image(size: PHImageManagerMaximumSize)
    }
    
    func image(size: CGSize) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image: UIImage?
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true
        option.resizeMode = .exact
        manager.requestImage(for: self,
                             targetSize: size,
                             contentMode: .aspectFit,
                             options: option,
                             resultHandler:
            { (result, info) -> Void in
                image = result
        })
        
        return image!
    }
}
