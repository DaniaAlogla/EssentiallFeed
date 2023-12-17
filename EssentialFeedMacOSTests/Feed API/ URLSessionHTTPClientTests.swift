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
        session.dataTask(with: url){ _,_,_ in }.resume()
    }
}
class URLSessionsHTTPClientTests: XCTestCase {
    
    
    func test_getFromURL_resumesDataTaskWithURL(){
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task:task)
        let sut = URLSessionsHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(task.resumeCallCount, 1)
    }
      
    // MARK: - Helpers
    private class URLSessionSpy: URLSession{
        var receivedURLs = [URL]()
        private var stubs = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task : URLSessionDataTask){
            stubs[url] = task
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            
            return stubs[url] ?? FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask  {
        override func resume() {
        }
        
    }
    private class URLSessionDataTaskSpy: URLSessionDataTask  {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }

}