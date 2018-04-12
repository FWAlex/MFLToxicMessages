//
//  OnboardingChildViewController3.swift
//  Pods
//
//  Created by Alex Miculescu on 22/09/2017.
//
//

import UIKit
import AVFoundation
import SpriteKit

class OnboardingChildViewController3: UIViewController {

    var style : Style!
    
    fileprivate let playIconSizeRatio = CGFloat(0.2)
    fileprivate var playIcon : PlayIcon!
    
    @IBOutlet fileprivate weak var contentLabel : UILabel!
    @IBOutlet fileprivate weak var contentView: UIView!
    @IBOutlet fileprivate weak var containerView: CircleView!
    @IBOutlet fileprivate weak var videoContainerView: CircleView!
    
    fileprivate var player : AVPlayer!
    fileprivate var playerLayer : AVPlayerLayer!
    fileprivate var skView : SKView!
    fileprivate var scene : SKScene!
    
    fileprivate let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 30)
    var text : String? {
        didSet {
            contentLabel.attributedText = text?.attributedString(style: textStyle,
                                                                 color: style.textColor4,
                                                                 alignment: .center)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerViewTapped(_:)))
        videoContainerView.addGestureRecognizer(tapGesture)
        
        videoContainerView.clipsToBounds = true
        
        setUpPlayer()
        setUpVideoView()
        setUpPlayerLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpScene()
        setUpEmitter()
    }
    
    fileprivate func setUpVideoView() {
        playIcon = PlayIcon()
        playIcon.color = style.primary
        playIcon.backgroundColor = .clear
        playIcon.isUserInteractionEnabled = false
        
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(playIcon)
        playIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        playIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        playIcon.widthAnchor.constraint(equalToConstant: 51).isActive = true
        playIcon.heightAnchor.constraint(equalToConstant: 51).isActive = true
    }
    
    fileprivate func setUpPlayer() {
        let videoPath = MFLCommon.shared.appBundle!.path(forResource: "onboardingView3_video", ofType: "mov")!
        let fileURL = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: fileURL)
        player.actionAtItemEnd = .pause
    }
    
    fileprivate func setUpPlayerLayer() {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoContainerView.layer.addSublayer(playerLayer!)
    }
    
    func parentDidLayoutSubviews() {
        playerLayer?.frame = videoContainerView.bounds
    }
    
    @objc fileprivate func playerViewTapped(_ sender: Any) {
        if player.rate != 0 && player.error == nil {
            pause()
        } else {
            play()
        }
    }
    
    fileprivate func play() {
        player.play()
        UIView.animate(withDuration: 0.1) { self.playIcon.alpha = 0.0 }
    }
    
    fileprivate func pause() {
        player.pause()
        UIView.animate(withDuration: 0.1) { self.playIcon.alpha = 1.0 }
    }
    
    fileprivate func setUpScene() {
        skView = SKView()
        
        contentView.addSubview(skView)
        contentView.sendSubview(toBack: skView)
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        skView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        skView.backgroundColor = .clear
        
        skView.allowsTransparency = true
        
        scene = SKScene(size: contentView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        skView.presentScene(scene)
    }
    
    fileprivate func setUpEmitter() {
        
        let totalDistance = min(scene.size.width, scene.size.height) / 2
        let speed = CGFloat(15)
        let lifetime = totalDistance / speed
        let keyframeDistance = containerView.bounds.width / 2 + 5
        let keyframe = NSNumber(value: Float(((keyframeDistance * lifetime) / totalDistance ) / lifetime))
        
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(image: UIImage(named: "onboardingView3_circle", bundle: MFLCommon.shared.appBundle)!)
        emitter.particleLifetime = lifetime
        emitter.particleBirthRate = 3
        emitter.particlePositionRange = CGVector(dx: 5, dy: 5)
        emitter.emissionAngle = .pi_270
        emitter.emissionAngleRange = 2.00
        emitter.particleSpeed = speed
        emitter.particleAlphaSequence = SKKeyframeSequence(keyframeValues: [1, 1, 0],
                                                           times: [0, keyframe, 1])
        emitter.particleScale = 0.60
        emitter.particleScaleRange = 0.3
        emitter.particleColor = style.secondary
        emitter.particleColorSequence = nil
        emitter.particleColorBlendFactor = 0
        emitter.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        emitter.advanceSimulationTime(60)
        emitter.targetNode = scene
        
        scene.addChild(emitter)
    }

}
