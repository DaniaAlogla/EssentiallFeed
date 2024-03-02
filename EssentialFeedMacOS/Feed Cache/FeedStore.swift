//
//  FeedStore.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 05/08/1445 AH.
//

import Foundation

public enum RetrivedCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrivedCachedFeedResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responisble to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responisble to dispatch to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage
    ], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responisble to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}

