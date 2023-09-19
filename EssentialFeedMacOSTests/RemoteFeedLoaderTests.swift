//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import Foundation
import XCTest
import EssentialFeedMacOS

class RemoteFeedLoaderTests : XCTest {
    
    func test_init_doesNotRequestDataFromURL(){
        let (_,client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL(){
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL,url)
    }
    
    func test_loadTwice_requestsDataFromURLCallTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader,client : HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    
    private class HTTPClientSpy : HTTPClient {
        var requestedURL: URL?
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedURL = url
            requestedURLs.append(url)
        }
    }
}
