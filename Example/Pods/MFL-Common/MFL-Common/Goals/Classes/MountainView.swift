//
//  MountainView.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 04/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

protocol MountainFeature {
    var relativeCentre: CGPoint? { get }
}

fileprivate enum Button: MountainFeature {
    
    case reset
    
    var relativeCentre: CGPoint? {
        switch self {
        case .reset: return CGPoint(x: 240, y: 252)
        }
    }
}

fileprivate enum Step: Int {
    
    case none = 0
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
}

extension Step: MountainFeature {

    static var visible = [Step.one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten]
    
    var number: Int {
        return rawValue
    }
    
    var label: String {
        return "\(number)"
    }
    
    static var size = CGSize(width: 32, height: 32)
    
    var relativeCentre: CGPoint? {
        switch self {
        case .none: return nil
        case .one: return CGPoint(x: 40, y: 252)
        case .two: return CGPoint(x: 80, y: 218)
        case .three: return CGPoint(x: 130, y: 194)
        case .four: return CGPoint(x: 188, y: 178)
        case .five: return CGPoint(x: 243, y: 166)
        case .six: return CGPoint(x: 277, y: 120)
        case .seven: return CGPoint(x: 218, y: 96)
        case .eight: return CGPoint(x: 160, y: 91)
        case .nine: return CGPoint(x: 120, y: 48)
        case .ten: return CGPoint(x: 158, y: 4)
        }
    }
}

extension MountainView {
    
    func frame(forSize size: CGSize, withRelativeCentre relativeCentre: CGPoint, referenceBoundsSize: CGSize) -> CGRect {
        
        let xRatio = referenceBoundsSize.width / bounds.width
        let yRatio = referenceBoundsSize.height / bounds.height
        let centre = CGPoint(x: relativeCentre.x / xRatio, y: relativeCentre.y / yRatio)
        let origin = CGPoint(x: centre.x - (size.width / 2), y: centre.y - (size.height / 2))
        let frame = CGRect(origin: origin, size: size)
        
        return frame
    }
}

protocol MountainViewDelegate: class {
    func mountainView(_ sender: MountainView, didUpdate progress: Int)
    func mountainView(_ sender: MountainView, didRequestMoreOptions: @escaping  ((Bool) -> Void))
    func mountainViewShouldShowMoreAction(_ sender: MountainView) -> Bool
}

class MountainView: HitTestInsetsView {
    
    static var referenceBoundsSize = CGSize(width: 320, height: 304)
    
    weak var delegate: MountainViewDelegate?
    
    fileprivate var mountainImageView: UIImageView!
    fileprivate var moreOptionsButton: RoundedButton!
    
    fileprivate var viewMappings = [(step: Step, view: StepView)]()
    
    var style : Style? {
        didSet {
            if let style = style {
                viewMappings.forEach { $0.view.style = style }
                moreOptionsButton.setTitleColor(style.primary, for: .normal)
                moreOptionsButton.borderColor = style.textColor1
            }
        }
    }
    
    var currentProgress: Int {
        get {
            return currentStep.number
        }
        set {
            minimumStep = Step(rawValue: newValue) ?? .none
            set(step: minimumStep, animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mountainImageView = UIImageView(image: UIImage(named: "mountains", bundle: MFLCommon.shared.appBundle))
        addSubview(mountainImageView)
        
        Step.visible.forEach { step in
            let view = StepView(number: step.number)
            view.delegate = self
            self.viewMappings.append((step: step, view: view))
            self.addSubview(view)
        }
        
        moreOptionsButton = RoundedButton(type: .system)
        moreOptionsButton.adjustsImageWhenHighlighted = true
        moreOptionsButton.intrinsicContentHeight = CGFloat(32)
        moreOptionsButton.setTitle(NSLocalizedString("More Options", comment: "button title"), for: .normal)
        moreOptionsButton.backgroundColor = .white
        moreOptionsButton.tintColor = .mfl_green
        moreOptionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        moreOptionsButton.addTarget(self, action: #selector(moreOptionsAction(_:)), for: .touchUpInside)
        self.addSubview(moreOptionsButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mountainImageView.frame = bounds
        
        viewMappings.forEach { mapping in
            let view = mapping.view
            view.frame = frame(forSize: Step.size, withRelativeCentre: mapping.step.relativeCentre ?? CGPoint.zero, referenceBoundsSize: MountainView.referenceBoundsSize)
        }
        
        moreOptionsButton.frame = frame(forSize: moreOptionsButton.intrinsicContentSize, withRelativeCentre: Button.reset.relativeCentre ?? CGPoint.zero, referenceBoundsSize: MountainView.referenceBoundsSize)
        
        if let moreAcctionHidden = self.delegate?.mountainViewShouldShowMoreAction(self) {
            setMoreActionHidden(moreAcctionHidden, animated: true)
        }
    }
    
    // MARK: Actions
    
    func moreOptionsAction(_ sender: UIButton) {
        delegate?.mountainView(self, didRequestMoreOptions: { [weak self] (shouldReset) in
            if shouldReset {
                self?.reset()
            }
        })
    }
    
    // MARK: Private
    
    var isEditable: Bool = true {
        didSet {
            isUserInteractionEnabled = isEditable
        }
    }
    
    fileprivate var minimumStep: Step = .one
    fileprivate var currentStep: Step {
        return viewMappings.reversed().first(where: { $0.view.isOn })?.step ?? .none
    }
    
    fileprivate func set(step: Step, animated: Bool) {
        
        let minimum: Int = minimumStep.number
        let from: Int = currentStep.number
        let to: Int = max(step.number, minimum)
        
        let toggle: ((Int, Bool?) -> Void) = { number, isOn in
            let i = number - 1
            if let view = self.viewMappings[safe: i]?.view {
                let new = isOn ?? !view.isOn
                view.set(isOn: new, animated: animated)
            }
        }
        
        // define updates
        
        var updates = [(() -> Void)]()
        
        if from == to {
            if to > minimum {
                updates.append { toggle(from, nil) } // only allow direct toggle of tapped on step
            }
        } else {
            let ascending: Bool = from < to ? true : false
            for n in stride(from: from, through: to, by: (ascending ? 1 : -1)) {
                let shouldToggle = ascending || (n > minimum && n != to) // if descending, leave selected step on
                if shouldToggle  {
                    updates.append { toggle(n, ascending) }
                }
            }
        }
        
        updates.append {
            self.delegate?.mountainView(self, didUpdate: self.currentStep.number)
        }

        perform(updates: updates, animated: animated)
    }
    
    fileprivate func perform(updates: [(() -> Void)], animated: Bool) {
        
        var updates = updates
        
        if animated {
            isUserInteractionEnabled = false
            updates.append { self.isUserInteractionEnabled = true }
            
            let duration = TimeInterval(0.5)
            let interval = duration / TimeInterval(updates.count)
            
            for (i, update) in updates.enumerated() {
                let delay = interval * TimeInterval(i)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { update() }
            }
        } else {
            updates.forEach { $0() }
        }
    }
    
    func reset() {
        minimumStep = .none
        set(step: .none, animated: true)
    }
    
    fileprivate func setMoreActionHidden(_ hidden: Bool, animated: Bool) {
        
        let update = {
            self.moreOptionsButton.alpha = hidden ? 0.0 : 1.0
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) { update() }
        } else {
            update()
        }
    }
}

extension MountainView: StepViewDelegate {
    
    func stepView(_ sender: StepView, shouldChangeState state: Bool) -> Bool {
        
        guard let step = viewMappings.find ({ sender == $0.view })?.step else { return true }
        
        set(step: step, animated: true)
        
        return false // we'll handle updates in order to time interim animations
    }
    
    func stepView(_ sender: StepView, didChangeState state: Bool) {
        
    }
}
