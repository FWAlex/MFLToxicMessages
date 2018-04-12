//
//  APIRouter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 26/01/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import Alamofire

public struct APIRouter {
    
    public let baseURL: URL
    let platform : String
    
    public init(baseURL: URL, platform: String) {
        self.baseURL = baseURL
        self.platform = platform
    }
    
    fileprivate func urlForRequestPath(_ pathComponents: String, parameters: [URLQueryItem]) -> URL {
        let url = self.baseURL.appendingPathComponent(pathComponents)
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponent.queryItems = parameters
        return urlComponent.url!
    }
    
    fileprivate func debug_URL(_ path: String) -> URL {
        let url = URL(string: "https://halsaserver.herokuapp.com")!
        return url.appendingPathComponent(path)
    }
    
    func request(_ path: String,
                             method: HTTPMethod = .get,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: HTTPHeaders? = nil,
                             isDebug: Bool = false) -> URLRequestConvertible {
        
        let url = isDebug ? debug_URL(path) : urlForRequestPath(path, parameters: [])
        return APIURLRequest(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    var accessToken : String {
        guard let accessToken = UserDefaults.mfl_accessToken else {
//            assertionFailure("Must be authorized to perform this call.")
            return ""
        }
        
        return accessToken
    }
}

//MARK: - Endpoints
extension APIRouter {
    
    //MARK: - Auth
    func refreshUserSessionToken(_ token: String) -> URLRequestConvertible {
        let headers = ["Authorization" : token]
        return request("/user/auth", method: .get, headers: headers)
    }
    
    func login(email: String, password: String) -> URLRequestConvertible {
        
        let parameters = [
            "username" : email,
            "password" : password,
            "platform" : self.platform
        ]
        
        return request("/user/auth", method: .post, parameters: parameters)
    }
    
    func register(with data: RegisterData) -> URLRequestConvertible {
        
        var parameters: Parameters = [
            "firstname" : data.firstName,
            "lastname" : data.lastName,
            // Fix: bypass for now
            "dateOfBirth" : "1990-01-01",
            
            "username" : data.email,
            "password" : data.password,
            "email" : data.email,
            "platform" : self.platform,
            "marketingOptOut": data.shouldReceivePromotions
        ]
        
        parameters["gender"] = {
            switch data.gender {
            case .male: return "M"
            case .female: return "F"
            case .agender: return "A"
            case .genderFluid: return "G"
            }
        }()
        
        return request("/user/signup", method: .post, parameters: parameters)
    }
    
    func verify(email: String) -> URLRequestConvertible {
        let parameters = ["email" : email]
        return request("/user/verify", method: .get, parameters: parameters)
    }
    
    func sendVerificationEmail(to email: String) -> URLRequestConvertible {
        let parameters = [
            "email" : email,
            "platform" : self.platform
            ]
        let headers = ["Authorization" : accessToken]
        return request("/user/send_verification_email", method: .post, parameters: parameters, headers: headers)
    }
    
    func retrievePassword(for email: String) -> URLRequestConvertible {
        let parameters = [
            "email" : email,
            "platform" : self.platform
        ]
        
        return request("/user/reset_password", method: .get, parameters: parameters)
    }
    
    //MARK: - User
    func updateUser(password: String) -> URLRequestConvertible {
        let params = ["password" : password]
        let headers = ["Authorization" : accessToken]
        return request("/user/my/password", method: .patch, parameters: params, headers: headers)
    }
    
    func updateUser(firstName: String?, lastName: String?) -> URLRequestConvertible {
        var params: [String : Any]? = nil
        
        if let firstName = firstName {
            if params == nil { params = [String : Any]() }
            params?["firstname"] = firstName
        }
        
        if let lastName = lastName {
            if params == nil { params = [String : Any]() }
            params?["lastname"] = lastName
        }
        
        let headers = ["Authorization" : accessToken]
        if let params = params {
            return request("/user/my/details", method: .patch, parameters: params, headers: headers)
        } else {
            return request("/user/my/details", method: .patch, headers: headers)
        }
    }
    
    func retrieveStripeCustomer() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/commercial/my/account", headers: headers)
    }
    
    func updateUser(ice: ICE) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = ice.json()
        
        return request("/user/my/details", method: .patch, parameters: params, headers: headers)
    }
    
    func getSessions() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        
        return request("/schedule/my/sessions", method: .get, headers: headers)
    }
    
    func cancel(_ session: Session) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        
        return request("/schedule/my/sessions/\(session.id)", method: .delete, headers: headers)
    }
    
    func fetchUserPackages() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/commercial/my/subscription", method: .get, headers: headers)
    }
    
    func deleteSubscription() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/commercial/my/subscription/", method: .delete, headers: headers)
    }
    
    func updateToSubscription(with id: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/commercial/my/subscription/\(id)", method: .patch, headers: headers)
    }
    
    func refreshUser() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/user/my/details", method: .get, headers: headers)
    }
    
    //MARK: - Journal
    func getJournalEntries() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        
        return request("/clinical/my/journals", method: .get, headers: headers)
    }
    
    func submitJournalEntry(with emotion: Emotion, reason: String?, moodTagIds: [String]?) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        
        var params = [String : Any]()
        params["emoji"] = emotion.toString()
        params["reason"] = reason ?? ""
        if let moodTagIds = moodTagIds, moodTagIds.count > 0 { params["moodTagIds"] = moodTagIds.map { Int($0)! } }
        
        return request("/clinical/my/journals", method: .post, parameters: params, headers: headers)
    }
    
    func getMoodTags() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = ["limit" : 20]
        
        return request("/clinical/moodtags", method: .get, parameters: params, headers: headers)
    }
    
    //MARK: - Questionnaire
    func fetchSignUpQuestionnaire() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/clinical/my/signup_questionnaire", method: .get, headers: headers)
    }
    
    func fetchQuestionnaire(with type: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = ["questionnaireId" : Int(type) ?? 0]
        return request("/clinical/my/questionnaire_responses", method: .post, parameters: params, headers: headers)
    }
    
    func update(questionnaire: Questionnaire) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = questionnaire.json()
        return request("/clinical/my/questionnaire_responses/\(questionnaire.responseId)", method: .patch, parameters: params, headers: headers)
    }
    
    func markAsComplete(questionnaire: Questionnaire) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/clinical/my/questionnaire_responses/\(questionnaire.responseId)/complete", method: .post, headers: headers)
    }
    
    //MARK: - Packages
    
    /** A list of all the products that are subscriptions (i.e. a list of all the packages) */
    func fetchPackages() -> URLRequestConvertible {
        let params = ["subscription" : "true"]
        let headers = ["Authorization" : accessToken]
        return request("/commercial/products", method: .get, parameters: params, headers: headers)
    }
    
    func fetchBoltons() -> URLRequestConvertible {
        let params = ["subscription" : "false"]
        let headers = ["Authorization" : accessToken]
        return request("/commercial/products", method: .get, parameters: params, headers: headers)
    }
    
    //MARK: - Payments
    func pay(for packageId: String, using stripeToken: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = ["token" : stripeToken]
        return request("/commercial/my/subscription/\(packageId)", method: .post, parameters: params, headers: headers)
    }
    
    func pay(for boltonId: String, stripeToken: String? = nil, cardId: String? = nil) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        var params = [String : Any]()
        if let stripeToken = stripeToken { params["token"] = stripeToken }
        if let cardId = cardId { params["cardId"] = cardId }
        
        return request("/commercial/my/boltons/\(boltonId)", method: .post, parameters: params, headers: headers)
    }
    
    func addCard(with stripeToken: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = ["token" : stripeToken]
        return request("/commercial/my/cards/default", method: .post, parameters: params, headers: headers)
    }
    
    //MARK: - Team 
    func team() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/user/team", headers: headers)
    }
    
    func assignedTherapist() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/user/my/mentor", headers: headers)
    }
    
    func requestNewTherapist(reason: String?) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        
        var params: [String : Any]? = nil
        
        if let reason = reason {
            params = [String : Any]()
            params?["reason"] = reason
        }
        
        return request("/user/my/mentor", method: .post, parameters: params, headers: headers)
    }
    
    //MARK: - Video Session
    func getVideoSessionTokens(for session: Session) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/messaging/my/groups/\(session.messageGroupId)/videos/access", method: .post, headers: headers)
    }
    
    //MARK: - Goals
    func fetchGoals() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/clinical/my/goals", method: .get, headers: headers)
    }
    
    func newGoal(title: String, desc: String, progress: Int) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        var params = [String : Any]()
        params["title"] = title
        params["description"] = desc
        params["score"] = progress
        return request("/clinical/my/goals", method: .post, parameters: params, headers: headers)
    }
    
    func deleteGoal(id: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/clinical/my/goals/\(id)", method: .delete, headers: headers)
    }
    
    func updateGoal(_ goal: Goal) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = goal.json()
        return request("/clinical/my/goals/\(goal.id)", method: .patch, parameters: params, headers: headers)
    }
    
    //MARK: - Branding
    func urlForTermsAndConditions() -> URL {
        return urlForRequestPath("/user/website/terms", parameters: [URLQueryItem(name: "platform", value: "\(platform)")])
    }
    
    //MARK: - Goals
    func fetchStageStep(uuid: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/content/pages/\(uuid)", method: .get, headers: headers)
    }
    
    func urlForAboutUs() -> URL {
        return urlForRequestPath("/user/website/about", parameters: [URLQueryItem(name: "platform", value: "\(platform)")])
    }
    
    //MARK: - CBM
    func fetchCBMSessions(userId: String) -> URLRequestConvertible {
        let params = ["userId" : userId]
        return request("/login", method: .post, parameters: params)
    }
    
    func postResultForCMBSession(session: CBMSession) -> URLRequestConvertible {
        let parameters = session.json()
        return request("/results", method: .post, parameters: parameters)
    }
}

//MARK: - APIURLRequest
struct APIURLRequest: URLRequestConvertible {
    
    private let url: URLConvertible
    private let method: HTTPMethod
    private let parameters: Parameters?
    private let encoding: ParameterEncoding
    private let headers: HTTPHeaders?
    
    func asURLRequest() throws -> URLRequest {
        let urlRequest = try URLRequest(url: url, method: method, headers: headers)
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    init( _ url: URLConvertible,
          method: HTTPMethod = .get,
          parameters: Parameters? = nil,
          encoding: ParameterEncoding = URLEncoding.default,
          headers: HTTPHeaders? = nil) {
        
        self.url = url
        self.method = method
        self.parameters = parameters
        
        if let headers = headers {
            var newHeaders = headers
            newHeaders["Accept"] = "text/plain"
            newHeaders["Content-Type"] = "application/json"
            self.headers = newHeaders
        } else {
            self.headers = [
                "Accept": "text/plain",
                "Content-Type" : "application/json"
            ]
        }
        
        if method == .post || method == .put || method == .patch {
            self.encoding = JSONEncoding.default
        } else {
            self.encoding = encoding
        }
    }
}

