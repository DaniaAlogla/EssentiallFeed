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
        
        sut.load { _ in}
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLCallTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in}
        sut.load { _ in}
        
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOn200HTTPResponce(){
        let (sut, client) = makeSUT()
        
        
        let samples = [199,201,300,400,500]
        
        samples.enumerated().forEach(){ index,code in
            
            
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: code,at: index)

            })
        }
        
    }
    
    func test_load_deliverErrorOn200ResponseWithInvalidJOSN(){
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJOSN = Data(bytes: "invalid josn".utf8)
            client.complete(withStatusCode: 200, data: invalidJOSN)
        })
        
        
    }
  
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJOSNList(){
        
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJOSN = Data(bytes: "{\"items\": []}".utf8)
            client.complete(withStatusCode: 200,data: emptyListJOSN)
        })

    }
    // Helpers
    

    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader,client : HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
        
    }
     
    private func expect(_ sut: RemoteFeedLoader , toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void,  file: StaticString = #filePath, line: UInt = #line) {
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load{capturedResults.append($0)}
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)

        
    }
    
    private class HTTPClientSpy : HTTPClient {
        
        private var messages = [(url:URL, completion : (HTTPClientResult) -> Void)]()
        
        var requestedURLs : [URL]{
            return messages.map {$0 .url}
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url,completion))

        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code : Int , data: Data = Data(), at index : Int = 0){
            let response = HTTPURLResponse(url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
    }
}
