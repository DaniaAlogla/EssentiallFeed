//
//  FeedRefershViewController.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 11/11/1445 AH.
//

import UIKit

final class FeedRefershViewController: NSObject {
    private(set) lazy var view = binded(FakeUIRefreshControl())
    
    private let viewMadel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewMadel = viewModel
    }
        
    @objc func refresh() {
        viewMadel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewMadel.onChange = { [weak self] viewMadel in
            if viewMadel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

private class FakeUIRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
