//
//  GroundingPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 26/09/2017.
//
//

import Foundation

class GroundingPresenterImplementation: GroundingPresenter {
    
    fileprivate let titleStyle = TextStyle(font: UIFont.systemFont(ofSize: 36, weight: UIFontWeightMedium), lineHeight: 42)
    fileprivate let subtitleStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), lineHeight: 24)
    fileprivate let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 36, weight: UIFontWeightMedium), lineHeight: 42)
    
    weak var delegate : GroundingPresenterDelegate?
    fileprivate let wireframe: GroundingWireframe
    fileprivate let items : [GroundingItem]
    
    typealias Dependencies = HasGroundingWireframe
    init(_ dependencies: Dependencies, items: [GroundingItem]) {
        wireframe = dependencies.wireframe
        self.items = items
    }
    
    func groundingItems(with style: Style) -> [GroundingViewType] {
        
        var groundingViewItems = [GroundingViewType]()
        
        for (index, item) in items.enumerated() {
            
            let image = UIImage(named: "grounding_\(index)", bundle: MFLCommon.shared.appBundle)
            
            switch item {
            case .titled(let title, let subtitle, let text):
                let groundingTitle = GroundingViewTitle(title: title, subtitle: subtitle)
                groundingViewItems.append(.titled(image, groundingTitle, text))
                
            case .simpleText(let text):
                groundingViewItems.append(.singleText(image, text))
            }
        }
        
        return groundingViewItems
    }
}




