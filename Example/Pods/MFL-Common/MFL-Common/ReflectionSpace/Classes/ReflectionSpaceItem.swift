//
//  ReflectionSpaceItem.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 04/10/2017.
//

import Foundation

public protocol ReflectionSpaceItem {
    var date : Date { get }
    var type : ReflectionSpaceItemType { get }
}

public enum ReflectionSpaceItemType {
    case image(name: String, thumbName: String)
    case video(name: String, thumbName: String)
}

