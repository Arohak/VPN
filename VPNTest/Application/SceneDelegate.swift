//
//  SceneDelegate.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let viewModel = MainViewModel(webService: WebService(), vpnService: VPNService(), storageService: StorageService())
        let viewController = MainViewController(viewModel: viewModel)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
