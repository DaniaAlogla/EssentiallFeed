//
//  File.swift
//  
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import Foundation

enum LoadFeedResult{
    case sucess ([FeedItem])
    case error (Error)
}

protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
