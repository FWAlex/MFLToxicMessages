//
//  BoltonDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class BoltonDataStoreImplementation : BoltonDataStore {
    
    
    fileprivate let networkManager : NetworkManager
    
    init(_ dependencies: HasNetworkManager) {
        networkManager = dependencies.networkManager
    }
    
    func fetchBoltons(handler: @escaping (Result<[Bolton]>) -> Void) {
        
        networkManager.fetchBoltons() {
            switch $0 {
            case .success(let json):
                var boltons = [Bolton]()
                for boltonJson in json["content"]["results"].arrayValue {
                    if let bolton = BoltonImplemetation(json: boltonJson) {
                        boltons.append(bolton)
                    }
                }
                handler(.success(boltons))
                
            case .failure(let error): handler(.failure(error))
            }
        }
        
    }
}

fileprivate struct BoltonImplemetation : Bolton {
    var id : String
    var name : String
    var desc : String
    var tokensCount : Int
    var durationInterval : Int
    var durationUnit : DurationUnit
    var price : Double
}

extension BoltonImplemetation : JSONDecodable {
    
    init?(json: MFLJson) {
        
        id = "\(json["id"].stringValue)"
        name = json["name"].stringValue
        desc = json["description"].stringValue
        tokensCount = json["noTokens"].intValue
        durationInterval = json["durationInterval"].intValue
        
        guard let durationUnit = DurationUnit(rawValue: json["durationUnit"].stringValue) else { return nil }
        self.durationUnit = durationUnit
        price = json["price"].doubleValue
    }
    
}

