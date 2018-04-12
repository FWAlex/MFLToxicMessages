//
//  ToxicMessagesPresenter.swift
//  MFLSexualAbuse
//
//  Created by Alex Miculescu on 23/11/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class ToxicMessagesPresenterImplementation: ToxicMessagesPresenter {
    
    weak var delegate : ToxicMessagesPresenterDelegate?
    fileprivate let wireframe: ToxicMessagesWireframe
    
    typealias Dependencies = HasToxicMessagesWireframe
    init(_ dependencies: Dependencies) {
        wireframe = dependencies.wireframe
    }
}
