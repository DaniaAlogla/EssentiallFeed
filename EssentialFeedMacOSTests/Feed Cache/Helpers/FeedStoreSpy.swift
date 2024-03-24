//
//  FeedStoreSpy.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 08/08/1445 AH.
//

import Foundation
import EssentialFeedMacOS

class FeedStoreSpy: FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    enum ReceivedMessage : Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var inertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCacheFeed)
    }
    
    func completionDeletion(with error: Error, at index: Int = 0){
        deletionCompletions[index](error)
    }
    
    func completionDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion){
        inertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0){
        inertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0){
        inertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
 
    func completeRetrieval(with error: Error, at index: Int = 0){
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0){
        retrievalCompletions[index](.success(.none))
    }
    
    func completeRetrieval(with images: [LocalFeedImage], timestamp: Date, at index: Int = 0){
        retrievalCompletions[index](.success(.some(CachedFeed(feed: images, timestamp: timestamp))))
    }
}

