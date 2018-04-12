//
//  Stage.swift
//  Pods
//
//  Created by Marc Blasi on 22/09/2017.
//
//

import Foundation

public protocol Stage {
    var title: String { get }
    var steps: [StageStep] { get }
    var index: Int { get }
}

public protocol StageStep {
    var title: String { get }
    var descriptionStep: String { get set }
    var lock: Bool { get }
    var imageName: String { get }
    var type: StageStepType { get }
}

public enum StageStepType: String {
    case page
    case assessment
    case none
    
    public init(rawValue: String) {
        switch rawValue {
        case StageStepType.page.rawValue: self = .page
        case StageStepType.assessment.rawValue: self = .assessment
        default: self = .none
        }
    }
    
    public var imageName: String {
        return self.rawValue
    }
}

public protocol StepPage: StageStep {
    var media: String? { get }
    var content: String { get }
}

public protocol StepAssessments: StageStep {
    var json: String { get }
}
