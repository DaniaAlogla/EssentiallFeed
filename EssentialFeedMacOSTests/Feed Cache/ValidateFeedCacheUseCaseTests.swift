//
//  ValidateFeedCacheUseCase.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 15/08/1445 AH.
//

import XCTest
import EssentialFeedMacOS

class ValidateFeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrivealError(){
        let (sut,store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCacheFeed])
    }
    
    func test_validtaeCache_dosNotDeletesCacheOnEmptyCache(){
        let (sut,store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve ])
    }
    
    func test_validateCache_dosNotDeleteLessThanSevenDaysOldCache(){
        let feed = uniqueImageFeed()
        let fixedCureentDate = Date()
        let lessThanSevenDaysOldTimestamp = fixedCureentDate.adding(days: -7 ).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCureentDate })
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesSevenDaysOldCache(){
        let feed = uniqueImageFeed()
        let fixedCureentDate = Date()
        let sevenDaysOldTimestamp = fixedCureentDate.adding(days: -7 )
        let (sut, store) = makeSUT(currentDate: { fixedCureentDate })
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCacheFeed])
    }
    
    func test_validateCache_deletesMoreThanSevenDaysOldCache(){
        let feed = uniqueImageFeed()
        let fixedCureentDate = Date()
        let MoreThanSevenDaysOldTimestamp = fixedCureentDate.adding(days: -7 ).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCureentDate })
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: MoreThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCacheFeed])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache()
        
        sut = nil
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init , file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut,store)
    }
    
}
