//
//  FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Dania Alogla on 21/08/1445 AH.
//

import Foundation

protocol FeedStoreSepcs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()

    func test_insert_overridesPreviouslyInsertedCacheValues()

    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()

    func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveFeedStoreSpecs : FeedStoreSepcs {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs : FeedStoreSepcs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}
  
protocol FailableDeleteFeedStoreSpecs : FeedStoreSepcs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnEmptyCache()
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
