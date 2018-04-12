//
//  JSON.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 19/02/2018.
//

public protocol MFLJson {
    
    subscript(key: String) -> MFLJson { get }
    
    var isEmpty : Bool { get }
    
    var bool : Bool? { get }
    var boolValue : Bool { get }
    
    var int : Int? { get }
    var intValue : Int { get }
    
    var string : String? { get }
    var stringValue : String { get }

    var double : Double? { get }
    var doubleValue : Double { get }
    
    var array : [MFLJson]? { get }
    var arrayValue: [MFLJson] { get }
    
    var rawString : String? { get }
}

public protocol MFLJsonDecoder {
    static func json(with data: Data) -> MFLJson
    static func json(with dictionaryLiteral: (key: String, value: Any)) -> MFLJson
    static func json(with array: [Any]) -> MFLJson
    static func json(with string: String) -> MFLJson
}

public class MFLDefaultJsonDecoder : MFLJsonDecoder { }
