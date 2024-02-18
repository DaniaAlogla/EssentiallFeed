//
//  FeedStore.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 05/08/1445 AH.
//

import Foundation

public protocol FeedStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage
    ], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve()
}

