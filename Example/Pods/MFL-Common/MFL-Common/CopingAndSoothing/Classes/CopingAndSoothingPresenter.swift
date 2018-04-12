//
//  CopingAndSoothingPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 23/10/2017.
//
//

import Foundation

class CopingAndSoothingPresenterImplementation: CopingAndSoothingPresenter {

    weak var delegate : CopingAndSoothingPresenterDelegate?
    fileprivate let interactor: CopingAndSoothingInteractor
    fileprivate let wireframe: CopingAndSoothingWireframe
    
    fileprivate var items = [ CopingAndSoothingMode : [CSActivity] ]()
    
    typealias Dependencies = HasCopingAndSoothingWireframe & HasCopingAndSoothingInteractor
    init(_ dependencies: Dependencies) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
    }
    
    func viewDidAppear() {
        delegate?.copingAndSoothingPresenter(self, wantsToPresentActivity: true)
        interactor.fetchActivities() { [unowned self] result in
            self.delegate?.copingAndSoothingPresenter(self, wantsToPresentActivity: false)
            
            switch result {
            case .success(let items):
                self.items[.doMore] = items.filter { $0.type == .doMore && $0.isSelected == true }
                self.items[.doLess] = items.filter { $0.type == .doLess && $0.isSelected == true }
                self.delegate?.copingAndSoothingPresenterWantsToUpdateActivities(self)
            case .failure(let error): self.delegate?.copingAndSoothingPresenter(self, wantsToPresent: error)
            }
        }
    }
    
    func itemsCount(for mode: CopingAndSoothingMode) -> Int {
        return items[mode]?.count ?? 0
    }
    
    func bodyForItem(at index: Int, mode: CopingAndSoothingMode) -> String {
        return items[mode]?[index].text ?? ""
    }
    
    func userWantsToEdit(_ mode: CopingAndSoothingMode) {
        wireframe.presentCopingAndSoothingDetailPage(for: mode)
    }
}
