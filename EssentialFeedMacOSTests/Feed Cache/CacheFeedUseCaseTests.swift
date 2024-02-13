//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 03/08/1445 AH.
//

import XCTest

class LocalFeedLoader {
    
    init (store: FeedStore) {
        
    }
}

class FeedStore {
    var deleteCachedFeedCallCoun = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCachUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCoun, 0)
    }
}
