//
//  RemoteFeedLoader.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 04/03/1445 AH.
//

import Foundation

public protocol HTTPClient{
    func get(from url:URL , completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    
    private let client : HTTPClient
    private let url : URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    
    public func load(completion: @escaping (Error) -> Void){
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
    
    public enum Error: Swift.Error {
        case connectivity
    }
}


