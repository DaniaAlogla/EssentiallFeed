//
//  File.swift
//  
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import Foundation

public protocol FeedLoader{
    typealias Result = Swift.Result<[FeedImage],Error>

    func load(completion: @escaping (Result) -> Void)
}
