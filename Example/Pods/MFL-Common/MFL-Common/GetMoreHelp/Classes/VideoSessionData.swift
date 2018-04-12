//
//  VideoSessionData.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

struct VideoSessionData {

    let apiKey : String
    let sessionId : String
    let token : String
}

extension VideoSessionData : JSONDecodable {
    
    init?(json: MFLJson) {
        
        self.apiKey = json["openTokApiKey"].stringValue
        self.sessionId = json["videoSessionId"].stringValue
        self.token = json["openTokToken"].stringValue
        
        if apiKey.isEmpty || sessionId.isEmpty || token.isEmpty {
            return nil
        }
    }
}
