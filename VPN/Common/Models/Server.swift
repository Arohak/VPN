//
//  Server.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation

struct Server: Codable {
    let id: Int
    let name: String
    let countryCode: String
    let status: Int
    let premiumOnly: Int
    let shortName: String
    let p2P: Int
    let tz: String
    let tzOffset: String
    let locType: String
    let forceExpand: Int?
    let dnsHostname: String
    let nodes: [Node]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case countryCode = "country_code"
        case status
        case premiumOnly = "premium_only"
        case shortName = "short_name"
        case p2P = "p2p"
        case tz
        case tzOffset = "tz_offset"
        case locType = "loc_type"
        case forceExpand = "force_expand"
        case dnsHostname = "dns_hostname"
        case nodes
    }
}
