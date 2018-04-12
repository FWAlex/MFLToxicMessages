//
//  HomeEmotionsViewController.swift
//  Pods
//
//  Created by Marc Blasi on 01/09/2017.
//
//

import UIKit

class HomeEmotionsViewController: MFLViewController {
    var presenter : HomeEmotionsPresenter!
    var style: Style!
    
    fileprivate let userImageSize = CGSize(width: 32.0, height: 32.0)
    fileprivate let emotionWaitTime = TimeInterval(2) // 2 seconds
    
    @IBOutlet weak var emotionsView: HomeEmotionsView!
    @IBOutlet weak var historyButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emotionsView.style = style
        emotionsView.delegate = self
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isHistoryButtonHidden = true
        if let emotion = presenter.selectedEmotion { emotionsView.setUpAnimationBeginState(for: emotion) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if presenter.selectedEmotion != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + emotionWaitTime) { [weak self] in
                self?.emotionsView.animateToDefault {
                    self?.presenter.verifyHasJournalEntries()
                }
            }
        } else {
            presenter.verifyHasJournalEntries()
        }
        
        presenter.viewDidAppear()
    }
    
    @IBAction func seeHaveYouBeenAction(_ sender: Any) {
        presenter.userWantsToViewPastJournal()
    }
    
    open var isHistoryButtonHidden : Bool {
        get { return historyButton.isHidden }
        set { historyButton.isHidden = newValue }
    }
}

//MARK: - HomePresenterDelegate
extension HomeEmotionsViewController: HomeEmotionsPresenterDelegate {
    func homePresenter(_ sender: HomeEmotionsPresenter, wantsToShowHasJournalEntries hasJournalEntries: Bool) {
        isHistoryButtonHidden = !hasJournalEntries
    }
}

//MARK: - HomeEmotionsViewDelegate
extension HomeEmotionsViewController : HomeEmotionsViewDelegate {
    func homeEmotionsView(_ sender: HomeEmotionsView, didSelect emotion: Emotion) {
         presenter.userWantsToSelect(emotion)
    }
    
    func homeEmotionsViewDidSelectHistory(_ sender: HomeEmotionsView) {
        
    }
}

