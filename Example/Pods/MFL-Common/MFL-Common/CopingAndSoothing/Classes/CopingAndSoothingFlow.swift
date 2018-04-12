//
//  CopingAndSoothingFlow.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//

import Foundation

enum CopingAndSoothingMode {
    case doMore
    case doLess
}

public class CopingAndSoothingFlow {
    
    public init () { /* Empty */ }
    
    fileprivate var flowDependencies : (HasNavigationController & HasNetworkManager & HasStyle)!
    fileprivate var introCompletion : (() -> Void)?
    
    public func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStyle) {
        flowDependencies = dependencies
        
        if shouldShowIntro() {
            moveToIntroPage()
        } else {
            moveToCopingAndSoothingPage(replaceTop: false)
        }
    }
    
    fileprivate func shouldShowIntro() -> Bool {
        let dataStore = DataStoreFactory.csActivityDataStore(networkManager: flowDependencies.networkManager)
        return !dataStore.hasUserOpenedFeature()
    }
}

//MARK: - Navigation
fileprivate extension CopingAndSoothingFlow {
    
    func moveToIntroPage() {
        var wireframe = CopingAndSoothingIntroFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(flowDependencies)
    }
    
    func moveToCopingAndSoothingPage(replaceTop: Bool) {
        var wireframe = CopingAndSoothingFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(flowDependencies, replaceTop: replaceTop)
    }
    
    func moveToCopingAndSoothingDetailPage(mode: CopingAndSoothingMode, isIntro: Bool) {
        var wireframe = CopingAndSoothingDetailFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(flowDependencies, mode: mode, isIntro: isIntro)
    }
}

//MARK: - CopingAndSoothingIntroWireframeDelegate
extension CopingAndSoothingFlow : CopingAndSoothingIntroWireframeDelegate {
    func copingAndSoothingIntroWireframe(_ sender: CopingAndSoothingIntroWireframe, wantsToPresentDetail mode: CopingAndSoothingMode, completion: @escaping () -> Void) {
        introCompletion = completion
        moveToCopingAndSoothingDetailPage(mode: mode, isIntro: true)
        let dataStore = DataStoreFactory.csActivityDataStore(networkManager: flowDependencies.networkManager)
        dataStore.setUserDidOpenFeature()
    }
    
    func copingAndSoothingIntroWireframeWantsToPresentCopingAndSoothingPage(_ sender: CopingAndSoothingIntroWireframe) {
        moveToCopingAndSoothingPage(replaceTop: true)
    }
}

//MARK: - CopingAndSoothingWireframeDelegate
extension CopingAndSoothingFlow : CopingAndSoothingWireframeDelegate {
    func copingAndSoothingWireframe(_ sender: CopingAndSoothingWireframe, wantsToPresentDetailPageFor mode: CopingAndSoothingMode) {
        moveToCopingAndSoothingDetailPage(mode: mode, isIntro: false)
    }
}

//MARK: - CopingAndSoothingWireframeDelegate
extension CopingAndSoothingFlow : CopingAndSoothingDetailWireframeDelegate {
    func copingAndSoothingDetailWireframeDidClose(_ sender: CopingAndSoothingDetailWireframe) {
        
    }
    
    func copingAndSoothingDetailWireframe(_ sender:  CopingAndSoothingDetailWireframe, didFinishWith mode: CopingAndSoothingMode) {
        let callback = introCompletion
        introCompletion = nil
        callback?()
    }
}
