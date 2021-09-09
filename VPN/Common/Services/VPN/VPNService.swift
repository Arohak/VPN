//
//  VPNService.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import NetworkExtension
import Combine

protocol VPNServiceProtocol: AnyObject {
    var event: PassthroughSubject<(status: NEVPNStatus, info: VPNInfo?), Never> { get }
    func connect(info: VPNInfo)
    func disconnect()
}

final class VPNService {
    private let manager = NEVPNManager.shared()
    private var info: VPNInfo?
    
    private var status: NEVPNStatus {
        return manager.connection.status
    }
    
    var event = PassthroughSubject<(status: NEVPNStatus, info: VPNInfo?), Never>()
    
    public init() {
        addObserver()
        loadProfile()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.event.send((self.status, self.info))
        }
    }
    
    private func loadProfile(completion: Completion<Bool>? = nil) {
        manager.protocolConfiguration = nil
        manager.loadFromPreferences { [unowned self] error in
            if let error = error {
                info?.server.identifier = error.localizedDescription
                event.send((status, info))
                completion?(false)
            } else {
                completion?(self.manager.protocolConfiguration != nil)
            }
        }
    }
    
    private func saveProfile(completion: Completion<Bool>? = nil) {
        manager.saveToPreferences { [unowned self] error in
            if let error = error {
                info?.server.identifier = error.localizedDescription
                event.send((status, info))
                completion?(false)
            } else {
                completion?(true)
            }
        }
    }
    
    private func saveInKeychain(_ password: String) -> Data? {
        guard let passwordData = password.data(using: .utf8, allowLossyConversion: false) else { return nil }
        let attributes: [NSObject: AnyObject] = [
            kSecAttrService: UUID().uuidString as AnyObject,
            kSecValueData: passwordData as AnyObject,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecClass: kSecClassGenericPassword,
            kSecReturnPersistentRef: kCFBooleanTrue
        ]
        var result: AnyObject?
        let status = SecItemAdd(attributes as CFDictionary, &result)
        
        if let newPersistentReference = result as? Data , status == errSecSuccess {
            return newPersistentReference
        }
        return nil
    }
}

// MARK: - VPNServiceProtocol
extension VPNService: VPNServiceProtocol {
    func connect(info: VPNInfo) {
        self.info = info

        let protocolIKEv2 = NEVPNProtocolIKEv2()
        protocolIKEv2.passwordReference = saveInKeychain(info.user.password)
        protocolIKEv2.username = info.user.name
        protocolIKEv2.serverAddress = info.server.address
        protocolIKEv2.remoteIdentifier = info.server.identifier
        protocolIKEv2.localIdentifier = info.server.identifier
        protocolIKEv2.useExtendedAuthentication = true
        protocolIKEv2.disconnectOnSleep = false
        protocolIKEv2.disableMOBIKE = false
        protocolIKEv2.disableRedirect = false
        protocolIKEv2.enableRevocationCheck = false
        protocolIKEv2.useConfigurationAttributeInternalIPSubnet = false
        protocolIKEv2.authenticationMethod = .none
        protocolIKEv2.deadPeerDetectionRate = .medium
        protocolIKEv2.childSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
        protocolIKEv2.childSecurityAssociationParameters.integrityAlgorithm = .SHA384
        protocolIKEv2.childSecurityAssociationParameters.diffieHellmanGroup = .group20
        protocolIKEv2.childSecurityAssociationParameters.lifetimeMinutes = 1440
        protocolIKEv2.ikeSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
        protocolIKEv2.ikeSecurityAssociationParameters.integrityAlgorithm = .SHA384
        protocolIKEv2.ikeSecurityAssociationParameters.diffieHellmanGroup = .group20
        protocolIKEv2.ikeSecurityAssociationParameters.lifetimeMinutes = 1440
         
        loadProfile { [unowned self] _ in
            manager.protocolConfiguration = protocolIKEv2
            manager.isEnabled = true
            manager.localizedDescription = "My VPN"
            
            saveProfile { [unowned self] success in
                if !success {
                    self.info?.server.identifier = "Unable to save vpn profile"
                    return
                }
                loadProfile() { [unowned self] success in
                    if !success {
                        self.info?.server.identifier = "Unable to load profile"
                        return
                    }
                    do {
                        try manager.connection.startVPNTunnel()
                    } catch NEVPNError.configurationInvalid {
                        self.info?.server.identifier = "Tunnel (configuration invalid)"
                    } catch NEVPNError.configurationDisabled {
                        self.info?.server.identifier = "Tunnel (configuration disabled)"
                    } catch {
                        self.info?.server.identifier = "Tunnel (other error)"
                    }
                }
            }
        }
    }
    
    func disconnect() {
        manager.onDemandRules = []
        manager.isOnDemandEnabled = false
        manager.saveToPreferences { [unowned self] _ in
            manager.connection.stopVPNTunnel()
        }
    }
}
