//
//  NetworkManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkManager {
    
    var detailedLog : Bool = false
    
    let router : APIRouter
    
    fileprivate lazy var sessionManager : SessionManager = {
        
        let sessionManager = SessionManager()
        sessionManager.startRequestsImmediately = false
        return sessionManager
    }()
    
    public init(router: APIRouter){
        self.router = router
    }
    
    func request(_ URLRequest: URLRequestConvertible, handler: @escaping (Result<MFLJson>) -> Void) -> DataRequest {
        
        
        let request = self.sessionManager
            .request(URLRequest)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json", "text/plain"])
            .responseData { response in
            
            self.printLogs(URLRequest: URLRequest, response: response)
            
            switch response.result {
                
            case .success(let rawData):
                
                let json = self.serialize(response: response.response!, data: rawData)
                if json.isEmpty {
                    handler(.failure(MFLError(status: .noContent)))
                }
                handler(.success(json))
                
            case .failure(let error):
                let error = self.error(forError: error as NSError, data: response.data, statusCode : response.response?.statusCode)
                handler(.failure(error))
            }
        }
        
        return self.detailedLog ? request.debugLog() : request
    }
    
    fileprivate func serialize(response: HTTPURLResponse, data: Data) -> MFLJson {
        
        if isPlainText(response: response) {
            let string = String(data: data, encoding: .utf8)!
            return MFLDefaultJsonDecoder.json(with: ("content", string))
        }
    
        let json = MFLDefaultJsonDecoder.json(with: data)
        return MFLDefaultJsonDecoder.json(with: ("content", json))
    }

    fileprivate func printLogs<T>(URLRequest: URLRequestConvertible, response : DataResponse<T>){
        
        if self.detailedLog {
            debugPrint(response)
            
            if let data = response.data, let string = String(data: data, encoding: .utf8), string.characters.count > 0 {
                let json = MFLDefaultJsonDecoder.json(with: string)
                print("[ResponseData]: \(json)")
            }
            
        }else{
            if let urlRequest = URLRequest.urlRequest, let method = urlRequest.httpMethod, let url = urlRequest.url {
                debugPrint("\(method): \(url)")
            }
        }
        
    }
    
    private func error(forError error : Error, data : Data?, statusCode : Int?) -> Error {
        
        guard let data = data, let string = String(data: data, encoding: .utf8), string.characters.count > 0 else {
            return error
        }
        
        let json = MFLDefaultJsonDecoder.json(with: string)
        
        if !json.isEmpty, let error = MFLError(json: json) {
            return error
        }
        
        if let statusCode = statusCode,
            let codeError = MFLError(code: statusCode) {
            return codeError
        }
        
        else {
            return MFLError(string: string)
        }
        
        
        
        
//        if serverError.status == .invalidToken {
//            let sessionExpired = FloatError(status: .invalidToken)
//            return sessionExpired
//        }
//         
//        if serverError.status != .unauthorized, let statusCode = statusCode, statusCode == 401 {
//            let unauthorisedError = FloatError(status: .unauthorized)
//            return unauthorisedError
//        }
    
    }
    
    //MARK: - Auth
    func refreshUserSessionToken(_ token: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.refreshUserSessionToken(token), handler: handler)
        request.resume()
    }
    
    func login(email: String, password: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.login(email: email, password: password), handler: handler)
        request.resume()
    }
    
    func register(with data: RegisterData, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.register(with: data), handler: handler)
        request.resume()
    }
    
    func verify(email: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.verify(email: email), handler: handler)
        request.resume()
    }
    
    func sendVerificationEmail(to email: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.sendVerificationEmail(to: email), handler: handler)
        request.resume()
    }
    
    func refreshUser(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.refreshUser(), handler: handler)
        request.resume()
    }
    
    func retrievePassword(for email: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.retrievePassword(for: email), handler: handler)
        request.resume()
    }
    
    //MARK: - User
    func updateUser(password: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.updateUser(password: password), handler: handler)
        request.resume()
    }
    
    func updateUser(firstName: String?, lastName: String?, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.updateUser(firstName: firstName, lastName: lastName), handler: handler)
        request.resume()
    }
    
    func retrieveStripeCustomer(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.retrieveStripeCustomer(), handler: handler)
        request.resume()
    }
    
    func updateUser(ice: ICE, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.updateUser(ice: ice), handler: handler)
        request.resume()
    }
    
    func getSessions(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.getSessions(), handler: handler)
        request.resume()
    }
    
    func cancel(_ session: Session, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.cancel(session), handler: handler)
        request.resume()
    }
    
    func deleteSubscription(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.deleteSubscription(), handler: handler)
        request.resume()
    }
    
    func updateToSubscription(with id: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.updateToSubscription(with: id), handler: handler)
        request.resume()
    }
    
    //MARK: - Journal
    func submitJournalEntry(with emotion: Emotion, reason: String?, moodTagIds: [String]?, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.submitJournalEntry(with: emotion, reason: reason, moodTagIds: moodTagIds), handler: handler)
        request.resume()
    }
    
    func getMoodTags(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.getMoodTags(), handler: handler)
        request.resume()
    }
    
    func getJournalEntries(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.getJournalEntries(), handler: handler)
        request.resume()
    }
    
    //MARK: - Questionnaire
    func fetchSignUpQuestionnaire(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchSignUpQuestionnaire(), handler: handler)
        request.resume()
    }
    
    func fetchQuestionnaire(with type: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchQuestionnaire(with: type), handler: handler)
        request.resume()
    }
        
    func update(questionnaire: Questionnaire, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.update(questionnaire: questionnaire), handler: handler)
        request.resume()
    }
    
    func markAsComplete(questionnaire: Questionnaire, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.markAsComplete(questionnaire: questionnaire), handler: handler)
        request.resume()
    }
    
    //MARK: - Packages
    /** The packages the user has subscribed to */
    func fetchUserPackages(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchUserPackages(), handler: handler)
        request.resume()
    }
    
    /** A list of all the products that are subscriptions (i.e. a list of all the packages) */
    func fetchPackages(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchPackages(), handler: handler)
        request.resume()
    }
    
    func fetchBoltons(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchBoltons(), handler: handler)
        request.resume()
    }
    
    //MARK: - Pay
    
    /** Pay for a package */
    func pay(for packageId: String, using stripeToken: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.pay(for: packageId, using: stripeToken), handler: handler)
        request.resume()
    }
    
    /** Pay for a bolton */
    func pay(for boltonId: String, stripeToken: String? = nil, cardId: String? = nil, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.pay(for: boltonId, stripeToken: stripeToken, cardId: cardId), handler: handler)
        request.resume()
    }
    
    func addCard(with stripeToken: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.addCard(with: stripeToken), handler: handler)
        request.resume()
    }
    
    //MARK: - Team
    func team(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.team(), handler: handler)
        request.resume()
    }
    
    func assignedTherapist(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.assignedTherapist(), handler: handler)
        request.resume()
    }
    
    func requestNewTherapist(reason: String?, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.requestNewTherapist(reason: reason), handler: handler)
        request.resume()
    }
    
    //MARK: - Video Session
    func getVideoSessionTokens(for session: Session, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.getVideoSessionTokens(for: session), handler: handler)
        request.resume()
    }
    
    //MARK: - Goals
    func fetchUserGoals(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchGoals(), handler: handler)
        request.resume()
    }
    
    func newGoal(title: String, desc: String, progress: Int, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.newGoal(title: title, desc: desc, progress: progress), handler: handler)
        request.resume()
    }
    
    func deleteGoal(id: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.deleteGoal(id: id), handler: handler)
        request.resume()
    }
    
    func updateGoal(_ goal: Goal, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.updateGoal(goal), handler: handler)
        request.resume()
    }
    
    //MARK: - Branding
    func urlForTermsAndConditions() -> URL {
        return router.urlForTermsAndConditions()
    }
    
    //MARK: - Stage
    func fetchStageStep(uuid: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchStageStep(uuid: uuid), handler: handler)
        print("Request= \(request)")
        request.resume()
    }
    
    func urlForAboutUs() -> URL {
        return router.urlForAboutUs()
    }
    
    //MARK: - CBM
    func fetchCBMSessions(for userId: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchCBMSessions(userId: userId), handler: handler)
        request.resume()
    }
    
    func sendCBMResultsFor(session: CBMSession, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.postResultForCMBSession(session: session), handler: handler)
        request.resume()
    }
}

//MARK: - Helper
extension NetworkManager {
    
    func isPlainText(response: HTTPURLResponse) -> Bool {
    
        if let contentType = response.allHeaderFields["Content-Type"] as? String {
            if (contentType.contains("text/plain")) {
                return true
            }
        }
        
        return false
    }
}

extension Alamofire.Request {
    func debugLog() -> Self {
        debugPrint(self)
        return self
    }
}
