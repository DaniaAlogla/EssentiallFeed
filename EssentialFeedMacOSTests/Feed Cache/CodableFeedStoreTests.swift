//
//  CodableFeedStoreTests.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 19/08/1445 AH.
//

import XCTest
import EssentialFeedMacOS

class CodableFeedStore {
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage : Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage){
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local : LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let storeURL : URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion){
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        do {
            let decoder = JSONDecoder()
            let cache = try decoder.decode(Cache.self, from: data)
            completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } catch {
            completion(.failure(error))
        }
        
    }
    
    func insert(_ feed: [LocalFeedImage
    ], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion){
        do {
            let encoder = JSONEncoder()
            let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
            let encoded = try encoder.encode(cache)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
        completion(nil)
    }

}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp()  {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache(){
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache(){
        let sut = makeSUT()
    
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache(){
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed,timestamp), to: sut)
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache(){
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed,timestamp), to: sut)
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retotrieve_deliversFailureOnRetrievalError(){
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "inavlid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retotrieve_hasNoSideEffectsOnFailure(){
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "inavlid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues(){
        let sut = makeSUT()
        
        let firstInsertionError = insert((uniqueImageFeed().local,Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let lastestFeed = uniqueImageFeed().local
        let lastestTimestamp = Date()
        let lastestInsertionError = insert((lastestFeed, lastestTimestamp), to: sut)
        
        XCTAssertNil(lastestInsertionError, "Expected to override cache successfully")
        expect(sut, toRetrieve: .found(feed: lastestFeed, timestamp: lastestTimestamp))
    }
    
    func test_insert_deliversErrorOnInsertionError(){
        let invalidStorURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStorURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache deletion")
        
        sut.deleteCachedFeed { deletionError in
            XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieve: .empty)
    }
    
    // - MARK : Helpers
    
    private func makeSUT(storeURL: URL? = nil ,  file: StaticString = #filePath,
                         line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut,file: file, line: line)
        return sut
    }
    
    @discardableResult
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: CodableFeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrival")
        var insertionError: Error?
         sut.insert(cache.feed, timestamp: cache.timestamp) { reveivedInsertionError in
             insertionError = reveivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func expect(_ sut : CodableFeedStore, toRetrieveTwice expectedResult: RetrivedCachedFeedResult, file: StaticString = #file , line : UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
    
    private func expect(_ sut : CodableFeedStore, toRetrieve expectedResult: RetrivedCachedFeedResult, file: StaticString = #file , line : UInt = #line) {
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
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func setupEmptyStoreState(){
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects(){
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts(){
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
        
    }
}
