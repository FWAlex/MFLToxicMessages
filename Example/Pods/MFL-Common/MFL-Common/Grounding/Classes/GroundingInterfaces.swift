//
//  GroundingInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 26/09/2017.
//
//

import UIKit

//MARK: - Presenter
protocol GroundingPresenterDelegate : class {
    
}

public enum GroundingItem {
    case titled(title: NSAttributedString?, subtitle: NSAttributedString?, text: NSAttributedString?)
    case simpleText(text: NSAttributedString?)
}

protocol GroundingPresenter {
    
    weak var delegate : GroundingPresenterDelegate? { get set }
    
    func groundingItems(with style: Style) -> [GroundingViewType]
}

//MARK: - Wireframe
public protocol GroundingWireframeDelegate : class {
    
}

public protocol GroundingWireframe {
    
    weak var delegate : GroundingWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStyle, items: [GroundingItem])
}
