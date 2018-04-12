//
//  ToxicMessagesInterfaces.swift
//  MFLSexualAbuse
//
//  Created by Alex Miculescu on 23/11/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Presenter

protocol ToxicMessagesPresenterDelegate : class {
    
}

protocol ToxicMessagesPresenter {
    
    weak var delegate : ToxicMessagesPresenterDelegate? { get set }
}

//MARK: - Wireframe

public protocol ToxicMessagesWireframeDelegate : class {
    
}

public protocol ToxicMessagesWireframe {
    
    weak var delegate : ToxicMessagesWireframeDelegate? { get set }
    
    func setUp(_ dependencies: HasStyle) -> UIViewController
}
