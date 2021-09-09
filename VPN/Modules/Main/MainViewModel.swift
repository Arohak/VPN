//
//  MainViewModel.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import UIKit
import Combine

enum Event {
    case web(MainViewState)
    case vpn(status: VPNStatus, info: VPNInfo?)
}

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}

final class MainViewModel: ViewModelType {
    struct Input {
        let viewIsReady: PassthroughSubject<Void, Never>
        let didSelect: PassthroughSubject<MainInnerItemCell.Data, Never>
        let didTapButton: PassthroughSubject<Void, Never>
    }
    typealias Output = PassthroughSubject<Event, Never>
    
    private var disposables = Set<AnyCancellable>()
    private var webService: WebServiceProtocol
    private var vpnService: VPNServiceProtocol
    private var storageService: StorageServiceProtocol

    init(webService: WebServiceProtocol, vpnService: VPNServiceProtocol, storageService: StorageService) {
        self.webService = webService
        self.vpnService = vpnService
        self.storageService = storageService
    }
    
    func transform(_ input: Input) -> Output {
        let output = PassthroughSubject<Event, Never>()

        input.viewIsReady
            .sink {
                fetchServerList()
                vpnEvent()
            }
            .store(in: &disposables)
        
        input.didSelect
            .sink { didSelect(data: $0) }
            .store(in: &disposables)
        
        input.didTapButton
            .sink { didTapButton() }
            .store(in: &disposables)
        
        func fetchServerList() {
            output.send(.web(.loading))
            webService.serverList()
                .sink { result in
                    switch result {
                    case .failure(let error):
                        output.send(.web(.failure(error)))
                        getFromStorage()
                    case .finished:
                        output.send(.web(.finished))
                    }
                } receiveValue: { response in
                    saveToStorage(servers: response.value.data)
                    let data = map(servers: response.value.data)
                    output.send(.web(.success(data)))
                }
                .store(in: &disposables)
        }
        
        func vpnEvent() {
            vpnService.event
                .sink { tuple in
                    switch tuple.status {
                    case .connected:
                        output.send(.vpn(status: .connected, info: tuple.info))
                    case .connecting:
                        output.send(.vpn(status: .connecting, info: tuple.info))
                    default:
                        output.send(.vpn(status: .disconnected, info: tuple.info))
                    }
                }
                .store(in: &disposables)
        }
        
        func didSelect(data: MainInnerItemCell.Data) {
            let user = VPNInfo.User(name: Configuration.User.name, password: Configuration.User.password)
            let server = VPNInfo.Server(address: data.dnsHostname, identifier: data.hostname)
            let info = VPNInfo(user: user, server: server)
            vpnService.connect(info: info)
        }
        
        func didTapButton() {
            vpnService.disconnect()
        }
        
        func map(servers: [Server]) -> MainViewData {
            var sections: [MainTableView.Section] = []
            servers.forEach { server in
                var rows: [MainTableView.Row] = [.head(data: .init(title: server.name, icon: Constants.sectionIcon, state: .close))]
                rows += server.nodes.map { node -> MainTableView.Row in
                    .inner(data: .init(dnsHostname: server.dnsHostname, hostname: node.hostname, tz: node.tz, icon: Constants.rowIcon))
                }
                let section = MainTableView.Section(allRows: rows)
                sections.append(section)
            }
            return .init(sections: sections)
        }
        
        func saveToStorage(servers: [Server]) {
            let backgroundContext = storageService.backgroundContext
            backgroundContext.perform {
                servers.forEach { server in
                    let serverObject = ServerObject(context: backgroundContext)
                    serverObject.update(with: server)
                    
                    let nodeObjects = server.nodes.map { node -> NodeObject in
                        let nodeObject = NodeObject(context: backgroundContext)
                        nodeObject.update(with: node)
                        nodeObject.server = serverObject
                        return nodeObject
                    }
                    
                    serverObject.addToNodes(NSSet(array: nodeObjects))
                }
                try? backgroundContext.save()
            }
        }
        
        func getFromStorage() {
            do {
                let serverObjects = try storageService.fetchObject(ServerObject.fetchRequest())
                let servers = serverObjects.map { $0.domainObject }
                let data = map(servers: servers)
                output.send(.web(.success(data)))
            } catch {
                output.send(.web(.failure(error)))
            }
        }
        
        return output
    }
}
