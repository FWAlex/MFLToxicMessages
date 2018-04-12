//
//  ReflectionSpaceDetailViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 06/10/2017.
//
//

import UIKit
import AVKit
import MediaPlayer

class ReflectionSpaceDetailViewController: MFLViewController {
    
    var presenter : ReflectionSpaceDetailPresenter!
    var style : Style!
    
    var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate lazy var closeBarButton : UIBarButtonItem = { return UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped(_:))) }()
    fileprivate lazy var playIcon : PlayIcon = {
        let playIcon = PlayIcon()
        playIcon.isUserInteractionEnabled = false
        return playIcon
    }()
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarStyle = .lightContent

        navigationItem.leftBarButtonItem = closeBarButton
        toolbar.tintColor = style.primary
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        switch presenter.displayItem {
        case .image(let image): setUpImage(image)
        case .video(let image, _): setUpVideo(with: image)
        }
        
        fitImageView(in: scrollView.frame.size)
    }
    
    func setUpImage(_ image: UIImage?) {
        NSLocalizedString("Photo", comment: "")
        imageView.image = image
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }
    
    func setUpVideo(with image: UIImage?) {
        NSLocalizedString("Video", comment: "")
        imageView.image = image
        scrollView.addSubview(playIcon)
        playIcon.color = style.primary
        playIcon.isHidden = false
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideo(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func fitImageView(in size: CGSize) {
        guard let image = imageView.image else {
            imageView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            return
        }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let scale = min(size.width / imageWidth, size.height / imageHeight)
        
        imageView.width = imageWidth * scale;
        imageView.height = imageHeight * scale;
        
        imageView.center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        scrollView.contentSize = scrollView.bounds.size
    }
    
    func centerPlayIcon() {
        if case .video(_, _) = presenter.displayItem {
            playIcon.frame.size = CGSize(width: 52, height: 52)
            playIcon.center = imageView.center
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    
        coordinator.animate(alongsideTransition: { _ in
            self.scrollView.zoomScale = 1.0
            self.fitImageView(in: self.scrollView.bounds.size)
            self.centerPlayIcon()
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if abs(scrollView.zoomScale - 1.0) < 0.0001 {
            fitImageView(in: scrollView.frame.size)
        }
        
        centerPlayIcon()
    }
    
    func closeTapped(_ sender: Any) {
        presenter.userWantsToClose()
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        presenter.userWantsToDelete()
    }
    
    func playVideo(_ sender: Any) {
        guard case .video(_, let url) = presenter.displayItem,
            let videoURL = url else {
            return
        }
        
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.modalTransitionStyle = .crossDissolve
        present(playerViewController, animated: true, completion: nil)
        player.play()
    }
}

extension  ReflectionSpaceDetailViewController : ReflectionSpaceDetailPresenterDelegate {
    func reflectionSpaceDetailPresenter(_ sender: ReflectionSpaceDetailPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension ReflectionSpaceDetailViewController : Rotatable {
    var supprotedInterfaceOrientations : UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}

extension ReflectionSpaceDetailViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if case .image(_) = presenter.displayItem { return imageView }
        else { return nil }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        imageView.center = CGPoint(x: (scrollView.contentSize.width ) * 0.5 + offsetX,
                                   y: (scrollView.contentSize.height ) * 0.5 + offsetY)
    }
}
