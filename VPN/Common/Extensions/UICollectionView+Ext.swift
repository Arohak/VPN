//
//  UICollectionView+Ext.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation
import UIKit

extension UICollectionReusableView {
    static var reuseId: String { return String(describing: self) }
}

extension UICollectionView {
    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: Cell.reuseId)
    }

    func registerHeader<Header: UICollectionReusableView>(_ headerClass: Header.Type) {
        register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId)
    }

    func registerFooter<Footer: UICollectionReusableView>(_ footerClass: Footer.Type) {
        register(footerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footer.reuseId)
    }

    func dequeueReusableCell<Cell: UICollectionViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as? Cell else {
            fatalError("fatal error for cell at \(indexPath)")
        }
        return cell
    }

    func dequeueHeaderView<Header: UICollectionReusableView>(_ indexPath: IndexPath) -> Header {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId, for: indexPath) as? Header else {
            fatalError("fatal error for header at \(indexPath)")
        }
        return view
    }

    func dequeueFooterView<Footer: UICollectionReusableView>(_ indexPath: IndexPath) -> Footer {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footer.reuseId, for: indexPath) as? Footer else {
            fatalError("fatal error for header at \(indexPath)")
        }
        return view
    }
}
