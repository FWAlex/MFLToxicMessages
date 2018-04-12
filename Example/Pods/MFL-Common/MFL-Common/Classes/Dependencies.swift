//
//  Dependencies.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 27/01/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import CoreData

//MARK: - User
public protocol HasUserPresistentStore {
    var userPersistentStore : UserPersistentStore! { get }
}


public protocol HasUserDataStore {
    var userDataStore : UserDataStore! { get }
}

public protocol HasUser {
    var user : User! { get }
}

//MARK: - RTCManager

public protocol HasRTCManager {
    var rtcManager : RTCManager! { get }
}

//MARK: - Stage
public protocol HasStagePersistentStore {
    var stagePersistentStore : StagePersistentStore! { get }
}

public protocol HasStageDataStore {
    var stageDataStore : StageDataStore! { get }
}

public protocol HasStageSelected {
    var stage : Stage! { get }
}

//MARK: - Journal
public protocol HasJournalEntryDataStore {
    var journalEntryDataStore : JournalEntryDateStore! { get }
}

public protocol HasJournalEntryPersistentStore {
    var journalEntryPersistentStore : JournalEntryPersistentStore! { get }
}

public protocol HasMoodTagDataStore {
    var moodTagDataStore : MoodTagDataStore! { get }
}

public protocol HasMoodTagPersistentStore {
    var moodTagPersistentStore : MoodTagPersistentStore! { get }
}

//MARK: - Packages
protocol HasPackage {
    var package : Package! { get }
}

public protocol HasPackagePersistentStore {
    var packagePersistentStore : PackagePersistentStore! { get }
}

public protocol HasPackageDataStore {
    var packageDataStore : PackageDataStore! { get }
}

public protocol HasBoltonDataStore {
    var boltonDataStore : BoltonDataStore! { get }
}
//
//protocol HasBolton {
//    var bolton : Bolton! { get }
//}

//MARK: - Chat
public protocol HasSession {
    var session : Session! { get }
}

//MARK: Questionnaire
public protocol HasQuestionnaireTracker {
    var questionnaireTracker: QuestionnaireTracker! { get }
}

public protocol HasQuestionnaireDataStore {
    var questionnaireDataStore : QuestionnaireDataStore! { get }
}

protocol HasQuestionnairePersistentStore {
    var questionnairePersistentStore : QuestionnairePersistentStore! { get }
}

protocol HasQuestionnaireManager {
    var questionnaireManager : QuestionnaireManager! { get }
}

//MARK: - Network
public protocol HasNetworkManager {
    var networkManager : NetworkManager! { get }
}

//protocol HasSocketManager {
//    var socketManager : SocketManager! { get }
//}
//
//protocol HasRTCManager {
//    var rtcManager : RTCManager! { get }
//}

//MARK: - UI
public protocol HasStyle {
    var style : Style! { get }
}

public protocol HasNavigationController {
    var navigationController : UINavigationController! { get }
}

public protocol HasViewController {
    var viewController : UIViewController! { get }
}

public protocol HasStoryboard {
    var storyboard : UIStoryboard! { get }
}

//MARK: - Core Data
public protocol HasManagedObjectContext {
    var moc : NSManagedObjectContext! { get }
}


//MARK: - Payment
public protocol HasPaymentManager {
    var paymentManager : PaymentManager! { get }
}

protocol HasPayable {
    var payable : Payable! { get }
}

//MARK: - Goals
public protocol HasGoalDataStore {
    var goalDataStore : GoalDataStore! { get }
}

public protocol HasGoalPersistentStore {
    var goalPersistentStore : GoalPersistentStore! { get }
}

//MARK: - Miscellaneous
public protocol HasAlertText {
    var alertText : AlertText! { get }
}

public protocol HasNavigationItem {
    var navigationItem: UINavigationItem! { get }
}

public protocol HasVideoChatProvider {
    var videoChatProvider : VideoChatProvider.Type! { get }
}
