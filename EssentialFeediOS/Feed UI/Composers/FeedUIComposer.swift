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
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefershViewController(presenter: presenter)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = refreshController
        presenter.feedView = FeedViewAdapter(contoller: feedController, imageLoader: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(foerwardingTo contoller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak contoller] feed in
            contoller?.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
            }
        }
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var contoller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(contoller: FeedViewController? = nil, imageLoader: FeedImageDataLoader) {
        self.contoller = contoller
        self.imageLoader = imageLoader
    }
    
    func display(feed: [FeedImage]) {
        contoller?.tableModel = feed.map { model in
            FeedImageCellController(viewModel: 
                FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }

}
