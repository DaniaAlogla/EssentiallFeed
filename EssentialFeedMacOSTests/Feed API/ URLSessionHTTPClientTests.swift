//
//   URLSessionHTTPClientTests.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 04/06/1445 AH.
//

import Foundation
import XCTest

class URLSessionsHTTPClient{
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL){
        session.dataTask(with: url){ _,_,_ in }
    }
}
class URLSessionsHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createDataTaskWithURL(){
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionsHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
      
    // MARK: - Helpers
    private class URLSessionSpy: URLSession{
        var receivedURLs = [URL]()
        
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask  {}
}
