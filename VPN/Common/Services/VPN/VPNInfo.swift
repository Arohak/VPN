//
//  VPNInfo.swift
//  VPN
//
//  Created by Ara Hakobyan on 09.09.21.
//

struct VPNInfo {
    struct User {
        let name: String
        let password: String
    }
    
    struct Server {
        var address: String
        var identifier: String
    }

    var user: User
    var server: Server
}
