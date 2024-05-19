//
//  FeedImageDataLoaderTask.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 11/11/1445 AH.
//

import Foundation

public protocol FeedImageDataLoaderTask {
   func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data,Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
