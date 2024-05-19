//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 11/11/1445 AH.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefershViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = adaptFeedToCellControllers(foerwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(foerwardingTo contoller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak contoller] feed in
            contoller?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: loader)
            }
        }
    }
}
