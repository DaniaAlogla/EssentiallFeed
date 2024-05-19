//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 01/11/1445 AH.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController , UITableViewDataSourcePrefetching {
    
    private var viewAppeared = false
    private var refreshController: FeedRefershViewController?
    var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }
    
    convenience init(refreshController: FeedRefershViewController) {
        self.init()
        self.refreshController = refreshController
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        tableView.prefetchDataSource = self
        refreshController?.refresh()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        if !viewAppeared {
            refreshControl?.beginRefreshing()
            viewAppeared = true
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

