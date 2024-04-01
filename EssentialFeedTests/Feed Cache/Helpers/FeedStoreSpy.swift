//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Dania Alogla on 08/08/1445 AH.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    typealias DeletionResult = Result<Void,Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void,Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Swift.Result<CachedFeed?,Error>
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
        deletionCompletions[index](.failure(error))
    }
    
    func completionDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion){
        inertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0){
        inertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0){
        inertionCompletions[index](.success(()))
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

