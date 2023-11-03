//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import XCTest
import EssentialFeedMacOS

class RemoteFeedLoaderTests : XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let (_,client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL(){
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLCallTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        var capturedError: RemoteFeedLoader.Error?
        
        sut.load{ error in capturedError = error }
        
        XCTAssertEqual(capturedError,.connectivity)
    }
    
  
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader,client : HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
        
    }
    
    
    private class HTTPClientSpy : HTTPClient {
        var requestedURLs = [URL]()
        var error : Error?
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}
