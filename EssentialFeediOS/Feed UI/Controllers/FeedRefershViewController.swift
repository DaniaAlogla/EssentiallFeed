//
//  FeedRefershViewController.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 11/11/1445 AH.
//

import UIKit

protocol FeedRefershViewControllerDelegate {
   func didRequestFeedRefresh()
}

final class FeedRefershViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()
    
    private let delegate: FeedRefershViewControllerDelegate
    
    init(delegate: FeedRefershViewControllerDelegate) {
        self.delegate = delegate
    }
        
    @objc func refresh() {
        delegate.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
}

