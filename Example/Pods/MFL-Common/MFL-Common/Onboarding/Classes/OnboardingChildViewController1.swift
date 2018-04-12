//
//  OnboardingChildViewController1.swift
//  Pods
//
//  Created by Alex Miculescu on 19/09/2017.
//
//

import UIKit
import SpriteKit

fileprivate let emitterPositionRatio = CGFloat(0.36)
fileprivate let sunSizeRatio_width = CGFloat(0.65)
fileprivate let sunPozRatio_x = CGFloat(0.24)
fileprivate let sunPozRatio_y = CGFloat(0.53)

fileprivate let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 30)

class OnboardingChildViewController1: UIViewController {

    var style : Style!
    
    @IBOutlet fileprivate weak var contentView: UIView!
    @IBOutlet fileprivate weak var contentLabel: UILabel!
    
    fileprivate var skView : SKView!
    fileprivate var scene : SKScene!
    fileprivate var waveNode : SKSpriteNode!
    
    fileprivate var prevW = CGFloat(0)
    fileprivate var prevH = CGFloat(0)
    
    var text : String? {
        didSet {
            contentLabel.attributedText = text?.attributedString(style: textStyle,
                                                                 color: style.textColor4,
                                                                 alignment: .center)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSkView()
    }
    
    
    func setUpSkView() {
        
        skView = SKView()
        skView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(skView)
        
        skView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        skView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        skView.allowsTransparency = true
        
        scene = SKScene(size: skView.frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        skView.presentScene(scene)
        
    }
    
    func addEmitter() {
        
        let maskImage = UIImage(named: "onboardingView1_mask1", bundle: MFLCommon.shared.appBundle)!
        let maskNode = SKSpriteNode(texture: SKTexture(image: maskImage))
        maskNode.color = .clear
        maskNode.size = waveNode.size
        maskNode.position = waveNode.position
        let aspectRatio = maskNode.size.height / maskImage.size.height
    
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(image: UIImage(named: "onboardingView1_circle", bundle: MFLCommon.shared.appBundle)!)
        emitter.particleLifetime = 100
        emitter.particleBirthRate = 3
        emitter.particlePositionRange = CGVector(dx: maskNode.size.width, dy: 5)
        emitter.emissionAngle = .pi / 2
        emitter.emissionAngleRange = 0
        emitter.particleSpeed = 20
        emitter.particleSpeedRange = 30
        emitter.particleAlpha = 1
        emitter.particleAlphaSpeed = -0.4 / (maskNode.size.height / maskImage.size.height)
        emitter.particleScale = 0.75
        emitter.particleScaleRange = 0.25
        emitter.particleColor = style.secondary
        emitter.particleColorSequence = nil
        emitter.particleColorBlendFactor = 0
        emitter.position = CGPoint(x: maskNode.size.width / 2, y: maskNode.size.height * emitterPositionRatio)
        emitter.zPosition = 8

        let sunImage = UIImage(named: "onboardingView1_sun", bundle: MFLCommon.shared.appBundle)!
        let sunNode = SKSpriteNode(texture: SKTexture(image: sunImage))
        let dimention = maskNode.size.width * sunSizeRatio_width
        sunNode.size = CGSize(width: dimention, height: dimention)
        let xPoz = (maskNode.position.x - maskNode.size.width / 2) + sunPozRatio_x * maskNode.size.width + sunNode.size.width / 2
        let yPoz = (maskNode.position.y - maskNode.size.height / 2) + sunPozRatio_y * maskNode.size.height + sunNode.size.height / 2
        sunNode.position = CGPoint(x: xPoz, y: yPoz)
        sunNode.zPosition = 9
        
        
        let cropNode = SKCropNode()
        cropNode.maskNode = maskNode
        cropNode.addChild(emitter)
        cropNode.addChild(sunNode)
        cropNode.zPosition = 10
        scene.addChild(cropNode)
        
        let oneRevolutionAction = SKAction.rotate(byAngle: -.pi * 2, duration: 30)
        let repeatAction = SKAction.repeatForever(oneRevolutionAction)
        sunNode.run(repeatAction)
    }
    
    func setUpWaveNode() {
        let image = UIImage(named: "onboardingView1_wave", bundle: MFLCommon.shared.appBundle)!
        waveNode = SKSpriteNode(texture: SKTexture(image: image))
        let scale = min(scene.size.width / image.size.width, scene.size.height / image.size.height)
        waveNode.size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        waveNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        waveNode.zPosition = 20
        
        scene.addChild(waveNode)
    }
    
    func setUpBackgroundNode() {
        let image = UIImage(named: "onboardingView1_background", bundle: MFLCommon.shared.appBundle)!
        let node = SKSpriteNode(texture: SKTexture(image: image))
        node.size = waveNode.size
        node.position = waveNode.position
        node.zPosition = 5
        
        scene.addChild(node)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scene.size = skView.bounds.size
    }
    
    func parentDidLayoutSubviews() {
        
        if !(contentView.width == prevW) || !(contentView.height == prevH) {
        
            scene.children.forEach { $0.removeFromParent() }
            
            scene.size = contentView.bounds.size
            setUpWaveNode()
            setUpBackgroundNode()
            addEmitter()
        }
    }
}

