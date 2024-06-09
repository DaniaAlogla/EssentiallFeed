//
//  UITableView+dequeueing.swift
//  EssentialFeediOS
//
//  Created by Dania Alogla on 03/12/1445 AH.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
