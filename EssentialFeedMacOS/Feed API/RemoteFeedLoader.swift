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
    
   public func load(){
        client.get(from: url)
        client.get(from: url)
    }
}

public protocol HTTPClient{
    func get(from url:URL)
}
