//
//  RemoteFeedLoader.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 04/03/1445 AH.
//

import Foundation


public final class RemoteFeedLoader {
    
    private let client : HTTPClient
    private let url : URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    
    public func load(completion: @escaping (Result) -> Void){
        client.get(from: url) { result in
            switch result{
            case let .success(data, response ):
                do {
                    let items = try FeedItemMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable{
        case success([FeedItem])
        case failure(RemoteFeedLoader.Error)
    }
    
    
}





