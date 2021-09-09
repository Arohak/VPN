//
//  Container.swift
//  VPN
//
//  Created by Ara Hakobyan on 09.09.21.
//

import Foundation

struct Container<T: Codable>: Codable {
    let data: T
}
