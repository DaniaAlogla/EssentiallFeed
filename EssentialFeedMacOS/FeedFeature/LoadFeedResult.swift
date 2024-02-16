//
//  File.swift
//  
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import Foundation

public enum LoadFeedResult{
    case success ([FeedImage])
    case failure (Error)
}


public protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
