//
//  NodeObject+DomainMapping.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation

extension NodeObject {
    var domainObject: Node {
        return Node(
            ip: ip ?? "",
            ip2: ip2 ?? "",
            ip3: ip3 ?? "",
            hostname: hostname ?? "",
            weight: Int(weight),
            group: group ?? "",
            gps: gps ?? "",
            tz: tz ?? "",
            type: type ?? "",
            wgPubkey: wgPubkey ?? "",
            proOnly: Int(proOnly)
        )
    }
}
