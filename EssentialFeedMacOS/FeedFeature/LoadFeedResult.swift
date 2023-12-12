//
//  File.swift
//  
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import Foundation

public enum LoadFeedResult{
    case success ([FeedItem])
    case failure (Error)
}


protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
