//
//  ServerObject+CoreDataProperties.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation
import CoreData

extension ServerObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServerObject> {
        return NSFetchRequest<ServerObject>(entityName: "ServerObject")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var tz: String?
    @NSManaged public var p2p: Int16
    @NSManaged public var shortName: String?
    @NSManaged public var premiumOnly: Int16
    @NSManaged public var status: Int16
    @NSManaged public var countryCode: String?
    @NSManaged public var dnsHostname: String?
    @NSManaged public var forceExpand: Int16
    @NSManaged public var locType: String?
    @NSManaged public var tzOffset: String?
    @NSManaged public var nodes: NSSet?

    func update(with server: Server) {
        self.id = Int32(server.id)
        self.name = server.name
        self.tz = server.tz
        self.p2p = Int16(server.p2P)
        self.shortName = server.shortName
        self.premiumOnly = Int16(server.premiumOnly)
        self.status = Int16(server.status)
        self.countryCode = server.countryCode
        self.dnsHostname = server.dnsHostname
        self.forceExpand = Int16(server.forceExpand ?? -1)
        self.locType = server.locType
        self.tzOffset = server.tzOffset
        
    }
}

// MARK: Generated accessors for nodes
extension ServerObject {
    @objc(addNodesObject:)
    @NSManaged public func addToNodes(_ value: NodeObject)

    @objc(removeNodesObject:)
    @NSManaged public func removeFromNodes(_ value: NodeObject)

    @objc(addNodes:)
    @NSManaged public func addToNodes(_ values: NSSet)

    @objc(removeNodes:)
    @NSManaged public func removeFromNodes(_ values: NSSet)

}

extension ServerObject : Identifiable {

}
