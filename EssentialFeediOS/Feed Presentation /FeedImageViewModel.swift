//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 13/11/1445 AH.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
