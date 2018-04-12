//
//  StagesViewController.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit


class StagesViewController: MFLViewController {

    var style: Style!
    var presenter : StagesPresenter!
    @IBOutlet weak var stepsCollectionView: UICollectionView!
    @IBOutlet weak var stepsDetailCollectionView: UICollectionView!
    var stepsCellFactory: CellFactory!
    var stepsDetailsCellFactory: CellFactory!
    @IBOutlet weak var shapeView: HalfElispeView!
    
    @IBOutlet weak var stageContainerView: UIView!
    lazy var stageView: StageView = {
        let stageView = StageView.mfl_viewFromNib(bundle: .stages) as! StageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StagesViewController.openStages))
        stageView.addGestureRecognizer(tapGesture)
        stageView.accessoryImage.setImageTemplate(named: "arrowForward", in: .common, color: .white)
        return stageView
    }()
    
    private let stepsCollectionViewItemSize = CGSize(width: 132, height: 132)
    
    @IBOutlet weak var stepsCollectionViewAspectRatioConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.delegate = self
        
        self.gradientLayerColors = style.gradient
        self.gradientStartPoint = CGPoint(x: 0.25, y: 0.0)
        self.gradientEndPoint = CGPoint(x: 0.75, y: 1.0)
        self.shouldUseGradientBackground = true
        self.shapeView.color = style.textColor1.withAlphaComponent(0.2)
        
        self.presenter.fetchStages()
        
        self.stageContainerView.addSubview(self.stageView)
        self.stageContainerView.topAnchor.constraint(equalTo: self.stageView.topAnchor,
                                       constant: 0).isActive = true
        self.stageContainerView.bottomAnchor.constraint(equalTo: self.stageView.bottomAnchor,
                                                     constant: 0).isActive = true
        self.stageContainerView.leftAnchor.constraint(equalTo: self.stageView.leftAnchor,
                                                        constant: 0).isActive = true
        self.stageContainerView.rightAnchor.constraint(equalTo: self.stageView.rightAnchor,
                                                      constant: 0).isActive = true
        
        stepsCellFactory = CellFactory(container: self.stepsCollectionView)
        stepsDetailsCellFactory = CellFactory(container: stepsDetailCollectionView)
        
        stepsCollectionView.alwaysBounceHorizontal = true
        
        let circularCollectionViewLayout = CircularCollectionViewLayout(itemSize: stepsCollectionViewItemSize)
        circularCollectionViewLayout.maxScale = 1.0
        circularCollectionViewLayout.minScale = 0.6
        circularCollectionViewLayout.yRadiusInset = stepsCollectionViewItemSize.height / 2
        circularCollectionViewLayout.xRadiusInset = 10
//        circularCollectionViewLayout.spacing = ((view.width / 2) - 3 * (stepsCollectionViewItemSize.width / 2)) / 2 + 10
        self.stepsCollectionView.setCollectionViewLayout(circularCollectionViewLayout, animated: false)
        self.stepsCollectionView.reloadData()
        self.stepsCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        stepsDetailCollectionView.setCollectionViewLayout(StepsDetailCollectionViewLayout(), animated: false)
        stepsDetailCollectionView.reloadData()
        stepsDetailCollectionView.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionDidFinish), name: MFLSubscriptionDidFinish, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        stepsCollectionViewAspectRatioConstraint.constant = -bottomLayoutGuide.length
        
        shapeView.radius = HalfElispeView.Radius(x: stepsCollectionView.width / 2 + 10,
                                                 y: stepsCollectionView.height)
        
        if self.presenter.needToResetTheWheel == true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.moveLastItem()
            }
            self.presenter.needToResetTheWheel = false
        }
    }
    
    @objc func openStages() {
        presenter.openSelectStages()
    }
    
    @objc fileprivate func subscriptionDidFinish() {
        // After a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            [weak self] in
            self?.presentChangeStage()
        }
    }
}

extension StagesViewController {
    func moveLastItem() {
        let lastIndexPath = IndexPath(row: self.stepsCollectionView.numberOfItems(inSection: 0)-1, section: 0)
        let attributes = self.stepsCollectionView.layoutAttributesForItem(at: lastIndexPath)
        
        self.stepsCollectionView.setContentOffset(CGPoint(x: self.stepsCollectionView.contentSize.width-self.stepsCollectionView.frame.width, y: 0), animated: false)
    }
}

extension StagesViewController: UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfSteps
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell
        let step = presenter.step(at: indexPath.row)
        
        if collectionView === stepsCollectionView {
            let stepCell = stepsCellFactory.dequeueReusableCell(StepCell.self, at: indexPath, in: .stages)
            stepCell.configure(with: step)
            cell = stepCell
        
        } else {
            let stepDetailCell = stepsDetailsCellFactory.dequeueReusableCell(StepDetailCell.self, at: indexPath, in: .stages)
            if stepDetailCell.style == nil { stepDetailCell.style = style }
            stepDetailCell.data = step
            cell = stepDetailCell
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === stepsCollectionView {
            stepsDetailCollectionView.horizontalScrollPercentage = scrollView.horizontalScrollPercentage
        }
    }
}

extension StagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectStep(index: indexPath.row)
    }
}

extension StagesViewController: StagesPresenterDelegate {
    func presentChangeStage() {
        self.stepsCollectionView.reloadData()
        self.stepsDetailCollectionView.reloadData()
        
        let stageDisplay = self.presenter.stageDisplay
        
        stageView.leftLabel.text = "\(stageDisplay.index)"
        stageView.titleLabel.text = stageDisplay.title
    }
}


class HalfElispeView : UIView {
    
    struct Radius {
        let x : CGFloat
        let y : CGFloat
        
        static let zero = Radius(x: 0.0, y: 0.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    private func initialize() {
        clipsToBounds = false
        backgroundColor = .clear
    }
    
    var color = UIColor.mfl_green { didSet { setNeedsDisplay() } }
    var radius = Radius.zero { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {

        var ovalRect = CGRect.zero
        ovalRect.origin.x = rect.width / 2 - radius.x
        ovalRect.origin.y = rect.height - radius.y
        ovalRect.size.width = 2.0 * radius.x
        ovalRect.size.height = 2.0 * radius.y
        
        color.setFill()
        
        UIBezierPath(ovalIn: ovalRect).fill()
    }
}



