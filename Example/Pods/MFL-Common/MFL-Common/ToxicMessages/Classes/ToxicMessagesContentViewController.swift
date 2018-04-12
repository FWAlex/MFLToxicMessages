//
//  ToxicMessagesContentViewController.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/11/2017.
//

import UIKit

enum ToxicMessagesType {
    case messages
    case beliefs
}

class ToxicMessagesContentViewController: UIViewController {

    weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate var imageSize : CGSize?
    
    var type : ToxicMessagesType? { didSet { updateType() } }
    
    private func updateType() {
        guard let type = type else { return }
        
        switch type {
        case .messages: set(image: UIImage(named: "toxic_messages_messages", bundle: MFLCommon.shared.appBundle))
        case .beliefs: set(image: UIImage(named: "toxic_messages_beliefs", bundle: MFLCommon.shared.appBundle))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        scrollView.addSubview(imageView)
        self.imageView = imageView
        
        scrollView.bounces = false
        scrollView.delegate = self
    }
    
    private func set(image: UIImage?) {
        guard let image = image else { return }
        
        imageView.image = image
        imageSize = image.size
        imageView.frame.size = imageSize!
        
        updateImageViewPosition()
        
        scrollView.minimumZoomScale = min(max(scrollView.bounds.width / imageSize!.width, scrollView.bounds.height / imageSize!.height), 1.0)
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateImageViewPosition()
    }
    
    private func updateImageViewPosition() {
        if imageView.width > scrollView.bounds.size.width &&
            imageView.height > scrollView.bounds.size.height {
            
            imageView.frame.origin = CGPoint.zero
            scrollView.contentSize = imageView.frame.size
            scrollView.contentOffset = CGPoint(x: (scrollView.contentSize.width / 2) - (scrollView.bounds.size.width / 2),
                                               y: (scrollView.contentSize.height / 2) - (scrollView.bounds.size.height / 2))
            
        } else if imageView.width < scrollView.bounds.size.width &&
            imageView.height > scrollView.bounds.size.height {
            
            imageView.frame.origin.x = (scrollView.bounds.size.width - imageView.width) / 2
            imageView.frame.origin.y = 0.0
            scrollView.contentSize = CGSize(width: imageView.frame.maxX, height: imageView.height)
            scrollView.contentOffset = CGPoint(x: 0.0, y: (scrollView.contentSize.height / 2) - (scrollView.bounds.size.height / 2))
            
        } else if imageView.width > scrollView.bounds.size.width &&
            imageView.height < scrollView.bounds.size.height {
            
            imageView.frame.origin.x = 0.0
            imageView.frame.origin.y = (scrollView.bounds.size.height - imageView.height) / 2
            scrollView.contentSize = CGSize(width: imageView.width, height: imageView.frame.maxY)
            scrollView.contentOffset = CGPoint(x: (scrollView.contentSize.width / 2) - (scrollView.bounds.size.width / 2), y: 0.0)
            
        } else {
            
            imageView.center = CGPoint(x: scrollView.bounds.width / 2, y: scrollView.bounds.height / 2)
            scrollView.contentSize = CGSize(width: imageView.frame.maxX, height: imageView.frame.maxY)
            scrollView.contentOffset = CGPoint.zero
            
        }
    }
}

extension ToxicMessagesContentViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        guard let imageSize = imageSize,
            imageSize.width < scrollView.bounds.width || imageSize.height < scrollView.bounds.height else { return }
        
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)

        imageView.center = CGPoint(x: (scrollView.contentSize.width ) * 0.5 + offsetX,
                                   y: (scrollView.contentSize.height ) * 0.5 + offsetY)
    }
}
