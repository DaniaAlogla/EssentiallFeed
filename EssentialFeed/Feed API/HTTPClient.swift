//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Dania Alogla on 02/05/1445 AH.
//

import Foundation

public protocol HTTPClient{
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responisble to dispatch to appropriate threads, if needed.
    func get(from url:URL , completion: @escaping (Result) -> Void)
}
