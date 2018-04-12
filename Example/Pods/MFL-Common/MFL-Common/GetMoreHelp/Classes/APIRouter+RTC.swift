//
//  APIRouter+RTC.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/10/2017.
//

import Alamofire

extension APIRouter {
   
    //MARK - RTC
    func sendRTC(message: String) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        let params = ["message" : message]
        return request("/messaging/message", method: .post, parameters: params, headers: headers)
    }
    
    func retrieveMessages(offset: Int?, limit: Int?) -> URLRequestConvertible {
        let headers = ["Authorization" : accessToken]
        var params: [String : Any]? = nil
        
        if let offset = offset {
            if params == nil { params = [String : Any]() }
            params?["offset"] = offset
        }
        
        if let limit = limit {
            if params == nil { params = [String : Any]() }
            params?["limit"] = limit
        }
        
        return request("/messaging/messages", method: .get, parameters: params, headers: headers)
    }
}
