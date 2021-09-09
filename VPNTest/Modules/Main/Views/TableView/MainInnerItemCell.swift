//
//  MainInnerItemCell.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import UIKit
import TinyConstraints

class MainInnerItemCell: UITableViewCell {
    private lazy var rightImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .secondaryLabel
        view.numberOfLines = 1
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(with data: Data) {
        titleLabel.text = data.title
        rightImageView.image = data.icon
    }

    private func buildUI() {
        let offset = Constants.maxOffset
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        contentView.addSubview(rightImageView)
        contentView.addSubview(titleLabel)

        titleLabel.centerYToSuperview()
        titleLabel.leadingToSuperview(offset: offset)
        titleLabel.trailingToLeading(of: rightImageView, offset: -offset, relation: .equalOrLess)
        titleLabel.setCompressionResistance(.defaultLow, for: .horizontal)

        rightImageView.centerYToSuperview()
        rightImageView.trailingToSuperview(offset: offset)
    }
}

// MARK: - Nested Type
extension MainInnerItemCell {
    struct Data {
        let dnsHostname: String
        let hostname: String
        let tz: String
        let icon: UIImage?
        
        var title: String {
            return "\(tz)   (\(hostname))"
        }
    }
}
