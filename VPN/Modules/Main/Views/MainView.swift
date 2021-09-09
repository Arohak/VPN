//
//  MainView.swift
//  VPN
//
//  Created by Ara Hakobyan on 09.09.21.
//

import UIKit

class MainView: UIView {
    public var didSelect: Completion<MainInnerItemCell.Data>?
    public var didTapButton: EmptyCompletion?

    private lazy var indicatorView = UIActivityIndicatorView(style: .medium)
    private lazy var topView = MainTopView()
    private lazy var tableView = MainTableView()
    
    public var data: MainViewData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(with state: MainViewState) {
        switch state {
        case .loading:
            indicatorView.startAnimating()
        case .failure(let error):
            topView.update(title: error.localizedDescription)
            indicatorView.stopAnimating()
        case .finished:
            indicatorView.stopAnimating()
        case .success(let data):
            self.data = data
            topView.update(with: data)
            tableView.update(with: data.sections)
            topView.didTapButton = didTapButton
            tableView.didSelect = didSelect
        }
    }
    
    public func updateTopView(with data: MainViewData) {
        topView.update(with: data)
    }
    
    private func buildUI() {
        backgroundColor = .systemTeal

        addSubview(topView)
        addSubview(tableView)
        addSubview(indicatorView)
        
        topView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        topView.height(Constants.topHeight)

        tableView.edgesToSuperview(excluding: .top, usingSafeArea: true)
        tableView.topToBottom(of: topView)
        
        indicatorView.centerInSuperview()
    }
}
