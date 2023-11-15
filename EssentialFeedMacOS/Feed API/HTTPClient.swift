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
    func get(from url:URL , completion: @escaping (HTTPClientResult) -> Void)
}
