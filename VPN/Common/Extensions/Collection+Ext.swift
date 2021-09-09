//
//  Collection+Ext.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation
import UIKit

typealias Completion<T> = (T) -> Void
typealias EmptyCompletion = () -> Void

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
