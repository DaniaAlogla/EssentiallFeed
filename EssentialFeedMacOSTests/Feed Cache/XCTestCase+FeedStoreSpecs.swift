//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 21/08/1445 AH.
//

import XCTest
import EssentialFeedMacOS

extension FeedStoreSepcs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrival")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { reveivedInsertionError in
            insertionError = reveivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut : FeedStore, toRetrieveTwice expectedResult: RetrivedCachedFeedResult, file: StaticString = #file , line : UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
    
    func expect(_ sut : FeedStore, toRetrieve expectedResult: RetrivedCachedFeedResult, file: StaticString = #file , line : UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve{ retrieveResult in
            
            switch (expectedResult,retrieveResult) {
                
            case (.empty,.empty),
                (.failure, .failure):
                break
                
            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(expected.timestamp, expected.timestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrieveResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
