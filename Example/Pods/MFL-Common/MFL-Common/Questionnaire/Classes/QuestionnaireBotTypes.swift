//
//  QuestionnaireBotTypes.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

enum QuestionnaireBotResult {
    case success(Questionnaire)
    case failure(Error)
}

enum QuestionInputType {
    case text
    case options([String])
}
