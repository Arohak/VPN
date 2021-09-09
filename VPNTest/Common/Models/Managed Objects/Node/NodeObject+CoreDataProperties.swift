//
//  NodeObject+CoreDataProperties.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation
import CoreData


extension NodeObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NodeObject> {
        return NSFetchRequest<NodeObject>(entityName: "NodeObject")
    }

    @NSManaged public var ip: String?
    @NSManaged public var ip2: String?
    @NSManaged public var ip3: String?
    @NSManaged public var hostname: String?
    @NSManaged public var weight: Int16
    @NSManaged public var group: String?
    @NSManaged public var gps: String?
    @NSManaged public var tz: String?
    @NSManaged public var type: String?
    @NSManaged public var wgPubkey: String?
    @NSManaged public var proOnly: Int16
    @NSManaged public var server: ServerObject?

    func update(with node: Node) {
        self.ip = node.ip
        self.ip2 = node.ip2
        self.ip3 = node.ip3
        self.hostname = node.hostname
        self.weight = Int16(node.weight)
        self.group = node.group
        self.gps = node.gps
        self.tz = node.tz
        self.type = node.type
        self.wgPubkey = node.wgPubkey
        self.proOnly = Int16(node.proOnly)
    }
}

extension NodeObject : Identifiable {

}
