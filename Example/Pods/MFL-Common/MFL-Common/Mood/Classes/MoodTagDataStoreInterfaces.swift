//
//  MoodTagsDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 05/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol MoodTagDataStore {
    func fetchTags(handler: @escaping (Result<[MoodTag]>) -> Void)
}

public protocol MoodTagPersistentStore {
    func moodTags(from json: MFLJson) -> [MoodTag]
    func getAllTags() -> [MoodTag]
}
