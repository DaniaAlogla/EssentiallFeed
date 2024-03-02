//
//  HTTPClient.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 02/05/1445 AH.
//

import Foundation

public enum HTTPClientResult{
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


public protocol HTTPClient{
    /// The completion handler can be invoked in any thread.
    /// Clients are responisble to dispatch to appropriate threads, if needed.
    func get(from url:URL , completion: @escaping (HTTPClientResult) -> Void)
}
