//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 03/08/1445 AH.
//

import XCTest
import EssentialFeedMacOS

class LocalFeedLoader {
    private let store: FeedStore
    init (store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        self.store.deleteCachedFeed()
    }
}

class FeedStore {
    var deleteCachedFeedCallCoun = 0
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCoun += 1
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCachUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCoun, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        let items = [uniqueItem(),uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCoun, 1)
    }
    
    // MARK: - Helpers
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
