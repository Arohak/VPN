//
//  ServerObject+DomainMapping.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation

extension ServerObject {
    var domainObject: Server {
        return Server(
            id: Int(id),
            name: name ?? "",
            countryCode: countryCode ?? "",
            status: Int(status),
            premiumOnly: Int(premiumOnly),
            shortName: shortName  ?? "",
            p2P: Int(p2p),
            tz: tz ?? "",
            tzOffset: tzOffset ?? "",
            locType: locType ?? "",
            forceExpand: Int(forceExpand),
            dnsHostname: dnsHostname ?? "",
            nodes: (nodes?.allObjects as? [NodeObject])?.map { $0.domainObject } ?? []
        )
    }
}
