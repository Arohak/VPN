//
//  MainViewData.swift
//  VPN
//
//  Created by Ara Hakobyan on 09.09.21.
//

import UIKit

enum MainViewState {
    case loading
    case success(MainViewData)
    case failure(Error)
    case finished
}

struct MainViewData {
    var title: String?
    var desc: String?
    var status: VPNStatus = .disconnected
    let sections: [MainTableView.Section]
    
    mutating func update(title: String?, desc: String?, status: VPNStatus) {
        self.title = title
        self.desc = desc
        self.status = status
    }
}

enum VPNStatus {
    case disconnected
    case connecting
    case connected
    
    var color: UIColor {
        switch self {
        case .disconnected: return .red
        case .connecting: return .gray
        case .connected: return .green
        }
    }
}
