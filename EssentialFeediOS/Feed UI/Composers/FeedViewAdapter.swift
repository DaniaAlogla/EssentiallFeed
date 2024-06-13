//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 07/12/1445 AH.
//

import EssentialFeed
import UIKit

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(contoller: FeedViewController? = nil, imageLoader: FeedImageDataLoader) {
        self.controller = contoller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
            controller?.tableModel = viewModel.feed.map { model in
                let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
                let view = FeedImageCellController(delegate: adapter)
                
                adapter.presenter = FeedImagePresenter(
                    view: WeakRefVirtualProxy(view),
                    imageTransformer: UIImage.init)
                
                return view
            }
        }
    
}
