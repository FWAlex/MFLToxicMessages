//
//  PastJournalEntryCell.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

final class PastJournalEntryCell : UITableViewCell, NibInstantiable, Reusable {
    
    @IBOutlet fileprivate weak var emotionImageView: UIImageView!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    
    var hasData = false {
        didSet {
            accessoryType = hasData ? .disclosureIndicator : .none
        }
    }
    
    var dateString : String? {
        get { return dateLabel.text }
        set { dateLabel.text = newValue }
    }

    var emotion : Emotion? {
        didSet {
            emotionImageView.image = emotion?.image
        }
    }
}

fileprivate extension Emotion {
    
    var image : UIImage {
        switch self {
        case .happy: return UIImage(named: "past_mood_emotion_happy", bundle: .mood)!
        case .neutral: return UIImage(named: "past_mood_emotion_neutral", bundle: .mood)!
        case .sad: return UIImage(named: "past_mood_emotion_sad", bundle: .mood)!
        }
    }
}
