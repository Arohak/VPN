//
//  UITableView+Ext.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseId: String { return String(describing: self) }
}

extension UITableViewHeaderFooterView {
    static var reuseId: String { return String(describing: self) }
}

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: Cell.reuseId)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell else {
            fatalError("fatal error for cell at \(indexPath)")
        }
        return cell
    }

    func registerHeaderFooter<View: UITableViewHeaderFooterView>(_ viewClass: View.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: View.reuseId)
    }

    func dequeueReusableHeaderFooter<View: UITableViewHeaderFooterView>() -> View {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: View.reuseId) as? View else {
            fatalError("fatal error for HeaderFooter View)")
        }
        return view
    }
}
