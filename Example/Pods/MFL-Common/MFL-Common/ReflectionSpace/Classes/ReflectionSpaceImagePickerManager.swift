//
//  ReflectionSpaceImagePickerManager.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/11/2017.
//

import Foundation
import UIKit
import PKHUD
import DKImagePickerController
import Photos
import AVFoundation
import MobileCoreServices
import MBProgressHUD

class ReflectionSpaceImagePickerManager : NSObject {
    
    fileprivate weak var navigationController : UINavigationController?
    fileprivate var contentCallback : ReflectionSpaceContentCallback?
    
    init(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func presentImagePicker(from source: UIImagePickerControllerSourceType, callback: ReflectionSpaceContentCallback?) {
        contentCallback = callback
        
        if source == .photoLibrary {
            requestAccessToLibrary() {
                if let alert = $0 {
                    self.handleCallback(with: alert)
                    return
                }
                
                self.presentImageFetcher(from: .photoLibrary)
            }
        } else {
            requestAccessToCamera() {
                if let alert = $0 {
                    self.handleCallback(with: alert)
                    return
                }
                
                self.requestAccessToMicrophone() {
                    if let alert = $0 {
                        self.handleCallback(with: alert)
                        return
                    }
                    
                    self.presentImageFetcher(from: .camera)
                }
            }
        }
    }
    
    private func requestAccessToLibrary(callback: @escaping (UIAlertController?) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized: callback(nil)
        case .denied: callback(libraryDeniedAlert())
        case .restricted: callback(libraryRestrictedAlert())
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() {
                switch $0 {
                case .authorized: DispatchQueue.main.async { callback(nil) }
                case .denied: DispatchQueue.main.async { callback(self.libraryDeniedAlert()) }
                case .restricted: DispatchQueue.main.async { callback(self.libraryRestrictedAlert()) }
                case .notDetermined: DispatchQueue.main.async{ self.requestAccessToLibrary(callback: callback) } // should not be possible to get here
                }
            }
        }
    }
    
    private func requestAccessToCamera(callback: @escaping (UIAlertController?) -> Void) {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
            
        case .authorized: DispatchQueue.main.async { callback(nil) }
        case .denied: callback(cameraDeniedAlert())
        case .restricted: callback(cameraRestrictedAlert())
            
        case .notDetermined: AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
            if granted { DispatchQueue.main.async { callback(nil) } }
            else { DispatchQueue.main.async { callback(self.cameraDeniedAlert()) } }
            }
        }
    }
    
    private func requestAccessToMicrophone(callback: @escaping (UIAlertController?) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission() { granted in
            if granted { DispatchQueue.main.async { callback(nil) } }
            else { DispatchQueue.main.async { callback(self.microphoneDeniedAlert()) } }
        }
    }
    
    private func libraryDeniedAlert() -> UIAlertController {
        return UIAlertController.okAlertWith(title: NSLocalizedString("Denied", comment: ""),
                                             message: NSLocalizedString("You have denied us access to your photo library. To allow access please do so via \"Settings\".", comment: ""))
    }
    
    private func libraryRestrictedAlert() -> UIAlertController {
        return UIAlertController.okAlertWith(title: NSLocalizedString("Restricted", comment: ""),
                                             message: NSLocalizedString("It seems you do not have permission to access this device's photo library.", comment: ""))
    }
    
    private func cameraDeniedAlert() -> UIAlertController {
        return UIAlertController.okAlertWith(title: NSLocalizedString("Denied", comment: ""),
                                             message: NSLocalizedString("You have denied us access to your camera. To allow access please do so via \"Settings\".", comment: ""))
    }
    
    private func cameraRestrictedAlert() -> UIAlertController {
        return UIAlertController.okAlertWith(title: NSLocalizedString("Restricted", comment: ""),
                                             message: NSLocalizedString("It seems you do not have permission to access this device's camera.", comment: ""))
    }
    
    private func microphoneDeniedAlert() -> UIAlertController {
        return UIAlertController.okAlertWith(title: NSLocalizedString("Denied", comment: ""),
                                             message: NSLocalizedString("You have denied us access to your microphone. To allow access please do so via \"Settings\".", comment: ""))
    }
    
    private func handleCallback(with alert: UIAlertController) {
        contentCallback?([ReflectionSpaceItemType](), alert)
        contentCallback = nil
    }
    
    private func presentImageFetcher(from source: UIImagePickerControllerSourceType) {
        
        if source == .photoLibrary {
            presentLibraryPicker()
        } else {
            presentCameraPicker()
        }
    }
    
    private func presentCameraPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.view.backgroundColor = .white
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeMovie, kUTTypeImage].map { $0 as String }
        
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentLibraryPicker() {
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 25
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            DispatchQueue(label: "saveAssets").async {

                var hud : MBProgressHUD?
                
                DispatchQueue.main.async {
                    guard let view = self.navigationController?.view else { return }
                    hud = MBProgressHUD.showAdded(to: view, animated: true)
                    hud?.mode = .annularDeterminate
                    hud?.label.text = NSLocalizedString("Processing your photos...", comment: "")
                }
                
                var items = [ReflectionSpaceItemType]()
                
                for (index, asset) in assets.enumerated() {
                    DispatchQueue.main.async { hud?.progress = Float(index) / Float(assets.count) }
                    
                    guard let phAsset = asset.originalAsset else {
                        continue
                    }
                    do {
                        if let item = try self.save(phAsset) { items.append(item) }
                        else {
                            continue
                        }
                    } catch {
                        continue
                    }
                }
                
                DispatchQueue.main.async {
                    hud?.hide(animated: true)
                    self.contentCallback?(items, nil)
                    self.contentCallback = nil
                }
            }
        }
        
        navigationController?.present(pickerController, animated: true) {}
    }
}

//MARK: - UINavigationControllerDelegate
extension ReflectionSpaceImagePickerManager : UINavigationControllerDelegate { /* Empty */ }

//MARK: - UIImagePickerControllerDelegate
extension ReflectionSpaceImagePickerManager : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var item: ReflectionSpaceItemType? = nil
        
        // IS IMAGE
        if let image = image(from: info) {
            HUD.show(.progress)
            DispatchQueue(label: "save_image").async {
                do {
                    item = try self.save(image)
                } catch { /* Empty */ }
                
                DispatchQueue.main.async {
                    HUD.hide()
                    self.closeImagePicker(with: item)
                }
            }
        }
            
            // IS VIDEO
        else if let url = videoURL(from: info) {
            HUD.show(.progress)
            DispatchQueue(label: "save_video").async {
                do {
                    item = try self.saveVideo(from: url)
                } catch { /* Empty */ }
                
                DispatchQueue.main.async {
                    HUD.hide()
                    self.closeImagePicker(with: item)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        contentCallback = nil
        navigationController?.dismiss(animated: true, completion: nil)
    }
}


    func image(from info: [String : Any]) -> UIImage? {
        if info[UIImagePickerControllerMediaType] as! String == kUTTypeImage as String {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                return image
            }
        }
        return nil
    }
    
    func videoURL(from info: [String : Any]) -> URL? {
        if info[UIImagePickerControllerMediaType] as! String == kUTTypeMovie as String {
            if let url = info[UIImagePickerControllerMediaURL] as? URL {
                return url
            }
        }
        return nil
    }

extension ReflectionSpaceImagePickerManager {
    
    func save(_ asset: PHAsset) throws -> ReflectionSpaceItemType? {
        switch asset.mediaType {
        
        case .image: return try save(asset.image())
        case .video:
            let videoData = asset.videoData()
            return videoData == nil ? nil : try saveVideo(videoData!, name: nil)
        default: return nil
        }
    }
    
    func save(_ image: UIImage) throws -> ReflectionSpaceItemType {
        let orientationFixedImage = image.fixOrientation()
        if let imageData = UIImagePNGRepresentation(orientationFixedImage),
            let thumbData = UIImagePNGRepresentation(orientationFixedImage.thumbnail()) {
            
            let imageName = uniqueNameForImage()
            let thumbName = imageName + "_thumb"
            _ = try FileManager.save(imageData, with: imageName)
            _ = try FileManager.save(thumbData, with: thumbName)
            
            return .image(name: imageName, thumbName: thumbName)
        }
        
        throw NSError(domain: "Cannot create image data", code: 90000, userInfo: nil)
    }
    
    func saveVideo(from url: URL) throws -> ReflectionSpaceItemType? {
        
        let name = url.absoluteString.components(separatedBy: "/").last!
        
        let data = try Data(contentsOf: url)
        return try saveVideo(data, name: name)
    }
    
    func saveVideo(_ data: Data, name: String?) throws -> ReflectionSpaceItemType? {
        
        let videoName = name ?? uniqueNameForVideo()
        
        _ = try FileManager.save(data, with: videoName)
        
        var thumbName = ""
        if let image = FileManager.videoSnapshotWith(videoName),
            let thumbData = UIImagePNGRepresentation(image.thumbnail()) {
            thumbName = "thumb_" + videoName
            _ = try FileManager.save(thumbData, with: thumbName)
        } else {
            throw NSError(domain: "Cannot create thumbnail data", code: 90000, userInfo: nil)
        }
        
        return .video(name: videoName, thumbName: thumbName)
    }
    
    func uniqueNameForImage() -> String {
        return "ReflectionImage-\(Int(Date.timeIntervalSinceReferenceDate * 1000))"
    }
    
    func uniqueNameForVideo() -> String {
        return "ReflectionVideo-\(Int(Date.timeIntervalSinceReferenceDate * 1000)).mp4"
    }
    
    func closeImagePicker(with item: ReflectionSpaceItemType?) {
        navigationController?.dismiss(animated: true) {
            let items = item == nil ? [ReflectionSpaceItemType]() : [item!]
            self.contentCallback?(items, nil)
            self.contentCallback = nil
        }
    }
}
