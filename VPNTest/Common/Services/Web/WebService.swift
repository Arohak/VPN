//
//  WebService.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import APIClient
import Combine
import Foundation

protocol WebServiceProtocol: AnyObject {
    func serverList() -> AnyPublisher<Response<Container<[Server]>>, Error>
}

// MARK: - WebServiceProtocol
class WebService: WebServiceProtocol {
    func serverList() -> AnyPublisher<Response<Container<[Server]>>, Error> {
        ServerListEndpoint.serverList.execute(type: Container<[Server]>.self)
    }
}
