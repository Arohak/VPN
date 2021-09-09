//
//  ServerListEndpoint.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import APIClient
import Foundation

enum ServerListEndpoint {
    case serverList
}

extension ServerListEndpoint: APIClient {
    var baseUrl: URL {
        Configuration.App.baseUrl
    }

    var path: String {
        return "/serverlist/ikev2/1/89yr4y78r43gyue4gyut43guy"
    }
}
