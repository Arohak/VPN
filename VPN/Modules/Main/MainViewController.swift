//
//  MainViewController.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    private lazy var rootView = MainView()
    private let viewModel: MainViewModel
    
    private let viewIsReady = PassthroughSubject<Void, Never>()
    private let didSelect = PassthroughSubject<MainInnerItemCell.Data, Never>()
    private let didTapButton = PassthroughSubject<Void, Never>()
    private var disposables = Set<AnyCancellable>()

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindViewModel()
        viewIsReady.send()
    }

    private func buildUI() {
        view = rootView
    }

    private func bindViewModel() {
        let output = viewModel.transform(.init(viewIsReady: viewIsReady, didSelect: didSelect, didTapButton: didTapButton))

        output
            .sink { [weak self] event in
                switch event {
                case .web(let state):
                    self?.rootView.didSelect = { [weak self] data in
                        self?.didSelect.send(data)
                    }
                    self?.rootView.didTapButton = {
                        self?.didTapButton.send()
                    }
                    self?.rootView.update(with: state)
                case .vpn(let status, let info):
                    guard var data = self?.rootView.data else { return }
                    data.update(title: info?.server.address, desc: info?.server.identifier, status: status)
                    self?.rootView.updateTopView(with: data)
                }
            }
            .store(in: &disposables)
    }
}
