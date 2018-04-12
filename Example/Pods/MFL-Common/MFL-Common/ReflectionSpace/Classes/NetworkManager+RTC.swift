//
//  NetworkManager+RTC.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/10/2017.
//


extension NetworkManager {
    //MARK: - RTC
    func sendRTC(message: String, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.sendRTC(message: message), handler: handler)
        request.resume()
    }
    
    func retrieveMessages(offset: Int?, limit: Int?, handler: @escaping (Result<MFLJson>) -> Void) {
        let request = self.request(router.retrieveMessages(offset: offset, limit: limit), handler: handler)
        request.resume()
    }
}
