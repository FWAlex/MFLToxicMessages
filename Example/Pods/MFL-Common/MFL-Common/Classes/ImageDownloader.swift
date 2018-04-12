//
//  ImageDownloader.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/03/2018.
//

import Foundation

fileprivate let filenameExtension = ".jpg"
fileprivate let directoryName = "MFLDownloadedImages"

public class ImageDownloader : Operation {
    
    /**
     * Will be called on the main queue
     */
    var successAction : (() -> Void)?
    var failureAction : (() -> Void)?
    
    fileprivate let imageUrlString : String
    fileprivate let force : Bool
    
    public init(imageUrlString: String, force: Bool = false) {
        self.imageUrlString = imageUrlString
        self.force = force
    }
    
    public override func main() {
        
        guard let imageName = ImageDownloader.imageName(from: imageUrlString) else { return }
        
        var shouldProceed = false
        
        DispatchQueue.main.sync {
            shouldProceed = !isImageDownloaded(imageName: imageName) || force
        }
        
        guard shouldProceed, let imageUrl = URL(string: imageUrlString) else {
            callAction(success: true)
            return
        }
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            
            DispatchQueue.main.sync {
                saveImage(data: imageData, named: imageName)
            }
            
            callAction(success: true)
            
        } catch {
            print("Encountered error: <\(error.localizedDescription)> when downloading image at \(imageUrlString).")
            callAction(success: false)
            return
        }
        
        print("Downloaded image at \(getDownloadsDirectory().appendingPathComponent(imageName + filenameExtension).path)")
    }
    
    public static func localImageData(for urlString: String) -> Data? {
        guard let name = imageName(from: urlString) else { return nil }
        let localUrl = getDownloadsDirectory().appendingPathComponent(name + filenameExtension)
        
        do {
            return try Data(contentsOf: localUrl)
        } catch {
            print("Could not find local data for image with url: \(urlString). Please make sure to prefetch the image first.")
            return nil
        }
    }
 
}

//MARK: - Helper
private extension ImageDownloader {
    
    static func imageName(from urlString: String) -> String? {
        var array = urlString.components(separatedBy: "/")
        
        guard let nameAndExtension = array.last else { return nil }
        return nameAndExtension.components(separatedBy: ".").first
    }
    
    func isImageDownloaded(imageName: String) -> Bool {
        let imageFileName = imageName + filenameExtension
        let fileURL = getDownloadsDirectory().appendingPathComponent(imageFileName)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    func saveImage(data: Data, named name: String) {
        let filename = getDownloadsDirectory().appendingPathComponent(name + filenameExtension)
        
        do {
            try data.write(to: filename)
        } catch {
            print("Encountered error \"\(error.localizedDescription)\" when writing to file image at \(imageUrlString).")
        }
    }
    
    func callAction(success: Bool) {
        DispatchQueue.main.async {
            if success {
                self.successAction?()
            } else {
                self.failureAction?()
            }
        }
    }
}

fileprivate func getDownloadsDirectory() -> URL {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let directoryURL = documentsDirectory.appendingPathComponent(directoryName)
    createDirectoryIfNoneExists(at:  directoryURL)
    
    return directoryURL
}

fileprivate func createDirectoryIfNoneExists(at url: URL) {
    do {
        try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print("Error creating directory: \(error.localizedDescription)")
    }
}
