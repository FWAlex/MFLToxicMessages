//
//  CopingAndSoothingDetailPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 26/10/2017.
//
//

import Foundation

class CopingAndSoothingDetailPresenterImplementation: CopingAndSoothingDetailPresenter {

    weak var delegate : CopingAndSoothingDetailPresenterDelegate?
    fileprivate let interactor  : CopingAndSoothingDetailInteractor
    fileprivate let wireframe   : CopingAndSoothingDetailWireframe
    fileprivate let mode : CopingAndSoothingMode
    fileprivate let isIntro : Bool
    fileprivate var items = [CSActivity]()
    
    typealias Dependencies = HasCopingAndSoothingDetailWireframe & HasCopingAndSoothingDetailInteractor
    init(_ dependencies: Dependencies, mode: CopingAndSoothingMode, isIntro: Bool) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
        self.mode = mode
        self.isIntro = isIntro
    }
    
    func viewWillAppear() {
        delegate?.copingAndSoothingDetailPresenter(self, wantsToShowActivity: true)
        
        interactor.fetchActivities() { [unowned self] result in
            
            self.delegate?.copingAndSoothingDetailPresenter(self, wantsToShowActivity: false)
            
            switch result {
            case .success(let activities):
                self.items = activities.filter { $0.type.mode == self.mode  }
                self.delegate?.copingAndSoothingDetailPresenterWantsToRefreshItems(self)
            case .failure(let error): self.delegate?.copingAndSoothingDetailPresenter(self, wantsToPresent: error)
            }
        }
    }
    
    var shouldShowCloseButton : Bool {
        return !isIntro
    }
    
    func userWantsToClose() {
        wireframe.close()
    }
    
    var barButtonText : String {
        if isIntro {
            switch mode {
            case .doMore: return NSLocalizedString("Next", comment: "")
            case .doLess: return NSLocalizedString("Done", comment: "")
            }
        } else {
            return NSLocalizedString("Done", comment: "")
        }
    }
    
    var itemsCount : Int {
        return items.count
    }
    
    func item(at index: Int) -> CopingAndSoothingDetailData {
        return CopingAndSoothingDetailData(items[index])
    }
    
    func userWantsToFinish() {
        wireframe.finish(mode)
    }
    
    var header : String {
        return mode.header
    }
    
    func userWantsToAdd(_ text: String) {
        delegate?.copingAndSoothingDetailPresenter(self, wantsToShowActivity: true)
        interactor.addActivity(with: text, type: mode.activityType) { [unowned self] result in
            self.delegate?.copingAndSoothingDetailPresenter(self, wantsToShowActivity: false)
            switch result {
            case .success(let activity):
                let index = self.itemsCount
                self.items.append(activity)
                self.delegate?.copingAndSoothingDetailPresenter(self, didAddNewItemAt: index)
            case .failure(let error): self.delegate?.copingAndSoothingDetailPresenter(self, wantsToPresent: error)
            }
        }
    }
    
    func userDidSelectItem(at index: Int) {
        delegate?.copingAndSoothingDetailPresenter(self, wantsToShowActivity: true)
        
        var activity = items[index]
        activity.isSelected = !activity.isSelected
        interactor.update(activity) { [unowned self] error in
            self.delegate?.copingAndSoothingDetailPresenter(self, wantsToShowActivity: false)
            
            if let error = error {
                self.delegate?.copingAndSoothingDetailPresenter(self, wantsToPresent: error)
                return
            }
            
            self.delegate?.copingAndSoothingDetailPresenter(self, didAddUpdateItemAt: index)
        }
    }
}

fileprivate extension CSActivityType {
    var mode : CopingAndSoothingMode {
        switch self {
        case .doLess: return .doLess
        case .doMore: return .doMore
        }
    }
}

fileprivate extension CopingAndSoothingMode {
    var header : String {
        switch  self {
        case .doMore: return NSLocalizedString("Which things from this list will you keep and make your own?", comment: "")
        case .doLess: return NSLocalizedString("Which things from this list do you want to do less of, or stop?", comment: "")
        }
    }
    
    var activityType : CSActivityType {
        switch self {
        case .doMore: return .doMore
        case .doLess: return .doLess
        }
    }
}

fileprivate extension CopingAndSoothingDetailData {
    init(_ activity: CSActivity) {
        isSelected = activity.isSelected
        text = activity.text
    }
}
