//
//  FeedCachePolicy.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 16/08/1445 AH.
//

import Foundation

 final class FeedCachePolicy {
    private init() {}
    
    private static let calender = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays : Int {
        return 7
    }
    
     static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calender.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
