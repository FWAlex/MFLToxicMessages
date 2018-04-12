//
//  NetworkLayer+CopingAndSoothing.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 24/10/2017.
//

import Alamofire

extension NetworkManager {
    func fetchActivities(handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.fetchActivities(), handler: handler)
        request.resume()
    }
    
    func addActivity(_ activity: CSActivity, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.addActivity(activity), handler: handler)
        request.resume()
    }
    
    func updateActivity(_ activity: CSActivity, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.updateActivity(activity), handler: handler)
        request.resume()
    }
}

extension APIRouter {
    func fetchActivities() -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        return request("/content/my/activities", method: .get, headers: headers)
    }
    
    func addActivity(_ activity: CSActivity) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = activity.json()
        return request("/content/my/activities", method: .post, parameters: params, headers: headers)
    }
    
    func updateActivity(_ activity: CSActivity) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = ["isSelected" : activity.isSelected]
        return request("/content/my/activities/\(activity.id)", method: .patch, parameters: params, headers: headers)
    }
}
