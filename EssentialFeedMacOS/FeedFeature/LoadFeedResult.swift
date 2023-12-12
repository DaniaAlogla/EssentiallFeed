//
//  File.swift
//  
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error>{
    case success ([FeedItem])
    case failure (Error)
}


protocol FeedLoader{
    associatedtype Error : Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
