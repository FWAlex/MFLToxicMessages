//
//  NetworkLayer+Questionnaire.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 04/12/2017.
//

import Foundation
import Alamofire

extension APIRouter {
    
    func getId(for assessment: Questionnaire) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let parameters = assessment.json()
        return request("content/my/assessments", method: .post, parameters: parameters, headers: headers)
    }
    
    
    func update(assessment: Questionnaire) throws -> URLRequestConvertible {
        guard !mfl_nilOrEmpty(assessment.id) else {
            let errorText = "The assessment: \(assessment), does not have an id."
            assertionFailure(errorText)
            throw MFLError(title: "Imvalid id", message: errorText)
        }
        
        let headers = ["Authorization" : accessToken]
        let parameters = assessment.json()
        return request("/content/my/assessments/\(assessment.id!)", method: .put, parameters: parameters, headers: headers)
    }
    
    func getLatestIncompleteAssessment(with slug: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let parameters: [String : Any] = ["slug" : slug, "latestIncompleteOnly" : "true"]
        return request("/content/my/assessments", method: .get, parameters: parameters, headers: headers)
    }
    
}

extension NetworkManager {
    
    func getId(for assessment: Questionnaire, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.getId(for: assessment), handler: handler)
        request.resume()
    }
    
    func update(assessment: Questionnaire, handler: @escaping (Result<MFLJson>) -> Void) throws {
        let request = try self.request(router.update(assessment: assessment), handler: handler)
        request.resume()
    }
    
    func getLatestIncompleteAssessment(with slug: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.getLatestIncompleteAssessment(with: slug), handler: handler)
        request.resume()
    }
}
