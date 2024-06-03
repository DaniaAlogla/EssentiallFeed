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

public final class FeedRefershViewController: NSObject, FeedLoadingView {
    @IBOutlet public var view: UIRefreshControl?
    
    var delegate: FeedRefershViewControllerDelegate?
        
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
    
}

