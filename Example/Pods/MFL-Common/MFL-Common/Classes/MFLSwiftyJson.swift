//
//  MFLSwiftyJson.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 20/02/2018.
//

import SwiftyJSON

struct MFLSwiftyJson : MFLJson {
    
    fileprivate var json : JSON
    
    init(data: Data) {
        json = JSON(data)
    }
    
    init(dictionaryLiteral: (String, Any)) {
        if let mflSwiftyJson = dictionaryLiteral.1 as? MFLSwiftyJson {
            json = JSON(dictionaryLiteral: (dictionaryLiteral.0, mflSwiftyJson.json))
        } else {
            json = JSON(dictionaryLiteral: dictionaryLiteral)
        }
    }
    
    init(string: String) {
        json = JSON(parseJSON: string)
    }
    
    fileprivate init(json: JSON) {
        self.json = json
    }
    
    fileprivate init(array: [Any]) {
        self.json = JSON(array)
    }
    
    subscript(key: String) -> MFLJson {
        return MFLSwiftyJson(json: self.json[key])
    }
    
    var isEmpty: Bool { return json.isEmpty }
    
    var bool : Bool? { return json.bool }
    var boolValue : Bool { return json.boolValue }
    
    var int: Int? { return json.int }
    var intValue: Int { return json.intValue }
    
    var string: String? { return json.string }
    var stringValue: String { return json.stringValue }
    
    var double: Double? { return json.double }
    var doubleValue: Double { return json.doubleValue }
    
    var array: [MFLJson]? {
        guard let array = json.array else { return nil }
        return mflJsonArray(from: array)
    }
    
    var arrayValue: [MFLJson] { return mflJsonArray(from: json.arrayValue) }
    
    var rawString: String? { return json.rawString() }
    
    private func mflJsonArray(from array: [JSON]) -> [MFLJson] {
        return array.map { MFLSwiftyJson(json: $0) }
    }
}

public extension MFLJsonDecoder {
    
    static func json(with data: Data) -> MFLJson { return MFLSwiftyJson(data: data) }
    
    static func json(with string: String) -> MFLJson { return MFLSwiftyJson(string: string) }
    
    static func json(with dictionaryLiteral: (key: String, value: Any)) -> MFLJson {
        return MFLSwiftyJson(dictionaryLiteral: dictionaryLiteral)
    }
     
    static func json(with array: [Any]) -> MFLJson {
        return MFLSwiftyJson(array: array)
    }
}
