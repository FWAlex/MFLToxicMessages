//
//  OnboardingChildViewController2.swift
//  Pods
//
//  Created by Alex Miculescu on 20/09/2017.
//
//

import UIKit
import SpriteKit

class OnboardingChildViewController2: UIViewController {
    
    @IBOutlet fileprivate weak var contentLabel: UILabel!
    @IBOutlet fileprivate weak var contentView: UIView!
    
    var style : Style!
    fileprivate var skView : SKView!
    fileprivate var scene : SKScene!
    
    fileprivate var messagesMaskNode : SKSpriteNode!
    fileprivate var messageSprite1 : SKSpriteNode!
    fileprivate var messageSprite2 : SKSpriteNode!
    fileprivate var messageSprite3 : SKSpriteNode!
    fileprivate var messagesCenterX : CGFloat {
        return messagesMaskNode.size.width / 2
    }
    
    fileprivate let messageBottomPaddingRatio1 = CGFloat(0.05)
    fileprivate var messageDefaultSize_1 : CGSize!
    fileprivate var messageDefaultSize_2 : CGSize!
    
    fileprivate var messageDefaultPoz_1 : CGPoint!
    fileprivate var messageDefaultPoz_2 : CGPoint!
    fileprivate var messageDefaultPoz_3 : CGPoint!
    
    fileprivate var layersSize : CGSize!
    fileprivate var sceneCenter : CGPoint {
        return CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
    }
    
    fileprivate let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 30)
    var text : String? {
        didSet {
            contentLabel.attributedText = text?.attributedString(style: textStyle,
                                                                 color: style.textColor4,
                                                                 alignment: .center)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpScene()
    }
    
    fileprivate func setUpScene() {
        
        skView = SKView()
        
        contentView.addSubview(skView)
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        skView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        skView.backgroundColor = .clear
        
        skView.allowsTransparency = true
        
        scene = SKScene(size: skView.frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        skView.presentScene(scene)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scene.size = contentView.bounds.size
        
        addBackground()
        addEmitter()
        addMessages()
        addTop()
        
        setToInitialState()
    }
    
    fileprivate func addBackground() {
        let backgroundImage = UIImage(named: "onboardingView2_background", bundle: MFLCommon.shared.appBundle)!
        let scale = min(scene.size.width / backgroundImage.size.width, scene.size.height / backgroundImage.size.height)
        layersSize = CGSize(width: backgroundImage.size.width * scale, height: backgroundImage.size.height * scale)
        
        let backgroundSprite = SKSpriteNode(texture: SKTexture(image: backgroundImage))
        backgroundSprite.size = layersSize
        backgroundSprite.position = sceneCenter
        backgroundSprite.zPosition = 0
        scene.addChild(backgroundSprite)
    }
    
    fileprivate func addEmitter() {
        let maskImage = UIImage(named: "onboardingView2_mask2", bundle: MFLCommon.shared.appBundle)!
        let maskNode = SKSpriteNode(texture: SKTexture(image: maskImage))
        maskNode.color = .clear
        maskNode.size = layersSize
        maskNode.position = sceneCenter
        
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(image: UIImage(named: "onboardingView2_circle", bundle: MFLCommon.shared.appBundle)!)
        emitter.particleLifetime = 100
        emitter.particleBirthRate = 1.5
        emitter.particlePositionRange = CGVector(dx: maskNode.size.width, dy: 5)
        emitter.emissionAngle = .pi_270
        emitter.emissionAngleRange = 0
        emitter.particleSpeed = 15
        emitter.particleSpeedRange = 5
        emitter.particleAlpha = 1
        emitter.particleAlphaSpeed = -0.10 / (maskNode.size.height / maskImage.size.height)
        emitter.particleScale = 0.60
        emitter.particleScaleRange = 0.3
        emitter.particleColor = style.secondary
        emitter.particleColorSequence = nil
        emitter.particleColorBlendFactor = 0
        emitter.position = CGPoint(x: sceneCenter.x, y: scene.size.height - 5)
        
        let cropNode = SKCropNode()
        cropNode.maskNode = maskNode
        cropNode.addChild(emitter)
        cropNode.zPosition = 1
        scene.addChild(cropNode)
    }
    
    fileprivate func addMessages() {
        let maskImage = UIImage(named: "onboardingView2_mask1", bundle: MFLCommon.shared.appBundle)!
        messagesMaskNode = SKSpriteNode(texture: SKTexture(image: maskImage))
        messagesMaskNode.color = .clear
        messagesMaskNode.size = layersSize
        messagesMaskNode.position = sceneCenter
        
        let messageImage1 = UIImage(named: "onboardingView2_message1", bundle: MFLCommon.shared.appBundle)!
        messageSprite1 = messageNode(image: messageImage1, widthRatio: messageImage1.size.width / maskImage.size.width)
        messageDefaultSize_1 = messageSprite1.size
        messageSprite1.position = CGPoint(x: sceneCenter.x, y: messageDefaultSize_1.height / 2 + layersSize.height * messageBottomPaddingRatio1)
        messageDefaultPoz_1 = messageSprite1.position
        
        let messageImage2 = UIImage(named: "onboardingView2_message2", bundle: MFLCommon.shared.appBundle)!
        messageSprite2 = messageNode(image: messageImage2, widthRatio: messageImage2.size.width / maskImage.size.width)
        messageDefaultSize_2 = messageSprite2.size
        position(messageSprite2, above: messageSprite1)
        messageDefaultPoz_2 = messageSprite2.position
        
        let messageImage3 = UIImage(named: "onboardingView2_message3", bundle: MFLCommon.shared.appBundle)!
        messageSprite3 = messageNode(image: messageImage3, widthRatio: messageImage3.size.width / maskImage.size.width)
        position(messageSprite3, above: messageSprite2)
        messageDefaultPoz_3 = messageSprite3.position
        
        let maskCrop = SKCropNode()
        maskCrop.maskNode = messagesMaskNode
        maskCrop.zPosition = 2
        maskCrop.addChild(messageSprite1)
        maskCrop.addChild(messageSprite2)
        maskCrop.addChild(messageSprite3)
        scene.addChild(maskCrop)
    }
    
    fileprivate func messageNode(image: UIImage, widthRatio: CGFloat) -> SKSpriteNode {
        let aspectRatio = image.size.width / image.size.height
        let sprite = SKSpriteNode(texture: SKTexture(image: image))
        let width = layersSize.width * widthRatio
        sprite.size = CGSize(width: width, height: width / aspectRatio)
        return sprite
    }
    
    fileprivate func addTop() {
        let topImage = UIImage(named: "onboardingView2_topLayer", bundle: MFLCommon.shared.appBundle)!
        let topSprite = SKSpriteNode(texture: SKTexture(image: topImage))
        topSprite.size = layersSize
        topSprite.position = sceneCenter
        topSprite.zPosition = 10
        scene.addChild(topSprite)
    }
    
    fileprivate func position(_ sprite1: SKSpriteNode, above sprite2: SKSpriteNode) {
        sprite1.position = CGPoint(x: sprite2.position.x, y: sprite2.position.y + (sprite2.size.height + sprite1.size.height) / 2)
    }
    
    func animate() {
        messageSprite1.removeAllActions()
        messageSprite2.removeAllActions()
        messageSprite3.removeAllActions()
        
        let action1_1 = SKAction.move(to: messageDefaultPoz_1, duration: 0.55)
        action1_1.timingMode = .easeOut
        
        let action1_2 = SKAction.resize(toWidth: messageDefaultSize_1.width, height: messageDefaultSize_1.height, duration: 0.55)
        action1_2.timingMode = .easeOut
        
        let actions1 = SKAction.group([action1_1, action1_2])
        messageSprite1.run(actions1)
        
        
        let action2_1 = SKAction.move(to: messageDefaultPoz_2, duration: 0.55)
        action2_1.timingMode = .easeOut
        
        let action2_2 = SKAction.resize(toWidth: messageDefaultSize_2.width, height: messageDefaultSize_2.height, duration: 0.55)
        action2_2.timingMode = .easeOut
        
        var actions2 = SKAction.group([action2_1, action2_2])
        actions2 = .sequence([.wait(forDuration: 0.1), actions2])
        messageSprite2.run(actions2)
        
        var actions3 = SKAction.move(to: messageDefaultPoz_3, duration: 0.55)
        actions3.timingMode = .easeOut
        actions3 = SKAction.sequence([.wait(forDuration: 0.2), actions3])

        messageSprite3.run(actions3)
    }
    
    func setToInitialState() {
        messageSprite1.removeAllActions()
        messageSprite2.removeAllActions()
        messageSprite3.removeAllActions()
        
        messageSprite1.position = CGPoint(x: sceneCenter.x, y: scene.size.height + messageSprite1.size.height / 2)
        position(messageSprite2, above: messageSprite1)
        position(messageSprite3, above: messageSprite2)
        
        messageSprite1.size = messageSprite3.size
        messageSprite2.size = messageSprite3.size
    }
}
