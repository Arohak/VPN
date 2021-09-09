//
//  MainTopView.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 09.09.21.
//

import UIKit

class MainTopView: UIView {
    public var didTapButton: EmptyCompletion?
    private let buttonWidth = Constants.topHeight/2

    private lazy var button: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = buttonWidth/2
        view.clipsToBounds = true
        view.setImage(Constants.statusIcon, for: .normal)
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.textColor = .label
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var descLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .label
        view.numberOfLines = 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(with data: MainViewData) {
        button.backgroundColor = data.status.color
        titleLabel.text = data.title
        descLabel.text = data.desc
    }
    
    public func update(title: String) {
        titleLabel.text = title
    }

    private func buildUI() {
        let offset = Constants.maxOffset

        addSubview(button)
        addSubview(titleLabel)
        addSubview(descLabel)

        button.centerYToSuperview()
        button.leadingToSuperview(offset: offset)
        button.width(buttonWidth)
        button.heightToWidth(of: button)

        titleLabel.centerYToSuperview(offset: -offset/1.5)
        titleLabel.leadingToTrailing(of: button, offset: offset)
        titleLabel.trailingToSuperview(offset: offset)

        descLabel.centerYToSuperview(offset: offset/1.5)
        descLabel.leading(to: titleLabel)
        descLabel.trailingToSuperview(offset: offset)
    }
    
    @objc private func buttonAction() {
        didTapButton?()
    }
}
