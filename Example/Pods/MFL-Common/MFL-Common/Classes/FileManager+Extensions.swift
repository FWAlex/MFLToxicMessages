//
//  FileManager+Extensions.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/10/2017.
//

import AVFoundation

extension FileManager {
    static func save(_ data: Data, with name: String) throws -> URL{
        let url = self.url(named: name)
        
        try data.write(to: url)
        return url
    }
    
    static func data(named name: String) -> Data? {
        let url = self.url(named: name)
        
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
    
    static func url(named name: String) -> URL {
        let dirs = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        return dirs[0].appendingPathComponent(name)
    }
    
    static func videoSnapshotWith(_ name: String) -> UIImage? {
        let url = FileManager.url(named: name)
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 0.1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            return image
        }
        catch {
            return nil
        }
    }
    
    static func delete(_ name: String) {
        let url = self.url(named: name)
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch { /* Empty */ }
    }
}

