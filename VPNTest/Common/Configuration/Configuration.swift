//
//  Configuration.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import Foundation

public enum Configuration: String {
    case debug
    case release

    static let current: Configuration = {
        guard var rawValue = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("No Configuration Found")
        }
        guard let configuration = Configuration(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }
        return configuration
    }()
}

// MARK: - App
extension Configuration {
    enum App {
        static let bundleIdentifier = "com.aro.hak.VPNTest"
        static let serverUrlString = "https://assets.windscribe.com"

        static var baseUrl: URL {
            switch current {
            case .debug: return URL(string: serverUrlString)!
            case .release: return URL(string: serverUrlString)!
            }
        }
    }
}

// MARK: - User
extension Configuration {
    enum User {
        static let name = "prd_test_j4d3vk6"
        static let password = "xpcnwg6abh"
    }
}
