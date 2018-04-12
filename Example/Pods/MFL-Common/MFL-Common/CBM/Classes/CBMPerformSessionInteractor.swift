//
//  CBMPerformSessionInteractor.swift
//  Pods
//
//  Created by Alex Miculescu on 13/03/2018.
//
//

import Foundation

enum ProbeType {
    case e
    case f
}

class CBMPerformSessionInteractorImplementation: CBMPerformSessionInteractor {
    
    fileprivate let presenter : CBMPerformSessionPresenter
    fileprivate let actions : CBMPerformSessionActions?
    fileprivate let cbmDataStore : CBMDataStore
    fileprivate var session : CBMSession
    fileprivate lazy var randomizedProbeType : [ProbeType] = { return self.createRandomiseProbeTypes() }()
    fileprivate var currentTrialIndex = 0
    fileprivate var currentTrial : CBMTrial?
    fileprivate var failureToSelectProbeTimer : Timer?

    typealias CBMPerformSessionInteractorDependencies = HasCBMPerformSessionPresenter & HasCBMDataStore
    
    init(_ dependencies: CBMPerformSessionInteractorDependencies, session: CBMSession, actions: CBMPerformSessionActions?) {
        presenter = dependencies.presenter
        cbmDataStore = dependencies.cbmDataStore
        self.session = session
        self.actions = actions
    }
    
    //MARK: - Exposed
    func viewDidAppear() {
        startTrial(currentTrialIndex)
    }
    
    func userDidFocus() {
        presenter.showImages(for: session.trials[currentTrialIndex])
    }
    
    func userDidSeeImages() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer in
            timer.invalidate()
            self?.presenter.hideImages()
            guard let sself = self else { return }
            self?.presenter.showProbe(type: sself.randomizedProbeType[sself.currentTrialIndex],
                                      for: sself.session.trials[sself.currentTrialIndex])
        }
    }
    
    func userDidSeeProbes() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer in
            timer.invalidate()
            self?.presenter.hideProbes()
            self?.currentTrial?.hidePorbeTimestamp = Date().timeIntervalSinceReferenceDate
            self?.presenter.enableInput()
            self?.failureToSelectProbeTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer in
                self?.invalidateFailureTimer()
                self?.userFailedToSelectProbe()
            }
        }
    }
    
    func userDidSeeMessage() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] timer in
            timer.invalidate()
            self?.presenter.hideMessage()
            self?.startNextTrial()
        }
    }
    
    func userDidSelectProbe_E() {
        userDidSelect(probe: .e)
    }
    
    func userDidSelectProbe_F() {
        userDidSelect(probe: .f)
    }
}

//MARK: - Call Actions
private extension CBMPerformSessionInteractorImplementation {
    func finish() {
        guard let action = actions?[.sessionFinished] as? ((CBMSession) -> Void) else { return }
        action(session)
    }
}

//MARK: - Helper
private extension CBMPerformSessionInteractorImplementation {
    
    func createRandomiseProbeTypes() -> [ProbeType] {
        
        var randomised = [ProbeType]()
        var halfAndHalf = (0 ..< session.trials.count).map { $0 < session.trials.count / 2 ? ProbeType.e : .f  }
        (0 ..< session.trials.count).forEach { _ in
            let i = arc4random_uniform(UInt32(halfAndHalf.count))
            randomised.append(halfAndHalf[Int(i)])
            halfAndHalf.remove(at: Int(i))
        }
    
        return randomised
    }
    
    func startTrial(_ trialIndex: Int) {
        
        guard trialIndex < session.trials.count else {
            finish()
            return
        }
        currentTrial = session.trials[currentTrialIndex]
        presenter.disableInput()
        presenter.focus()
    }
    
    func userDidSelect(probe: ProbeType) {
        invalidateFailureTimer()
        
        if probe == randomizedProbeType[currentTrialIndex] {
            currentTrial?.userSelectTimestamp = Date().timeIntervalSinceReferenceDate
            startNextTrial()
        } else {
            currentTrial?.userSelectedWrongProbe = true
            presenter.disableInput()
            presenter.showBadSelection()
        }
    }
    
    func userFailedToSelectProbe() {
        currentTrial?.userFailedToSelect = true
        presenter.disableInput()
        presenter.showFailureToSelect()
    }
    
    func invalidateFailureTimer() {
        failureToSelectProbeTimer?.invalidate()
        failureToSelectProbeTimer = nil
    }
    
    func startNextTrial() {
        currentTrialIndex += 1
        startTrial(currentTrialIndex)
    }
}
