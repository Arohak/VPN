//
//  MainItemCell.swift
//  VPN
//
//  Created by Ara Hakobyan on 08.09.21.
//

import UIKit
import TinyConstraints

class MainItemCell: UITableViewCell {
    private lazy var leftImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.textColor = .secondaryLabel
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
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
        leftImageView.image = data.icon
        titleLabel.text = data.title
        rightImageView.image = data.state.icon
    }

    private func buildUI() {
        let offset = Constants.offset
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightImageView)

        leftImageView.centerYToSuperview()
        leftImageView.leadingToSuperview(offset: offset)
        leftImageView.width(Constants.iconWidth)
        leftImageView.heightToWidth(of: rightImageView)
        
        titleLabel.centerYToSuperview()
        titleLabel.leadingToTrailing(of: leftImageView, offset: offset)
        titleLabel.trailingToLeading(of: rightImageView, offset: -offset, relation: .equalOrLess)

        rightImageView.centerYToSuperview()
        rightImageView.trailingToSuperview(offset: offset)
        rightImageView.width(Constants.iconWidth)
        rightImageView.heightToWidth(of: rightImageView)
    }
}

// MARK: - Nested Type
extension MainItemCell {    
    struct Data {
        let title: String
        var icon: UIImage?
        var state: State
    }
    
    enum State {
        case open, close
        
        var opposite: Self {
            switch self {
            case .open: return .close
            case .close: return .open
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .close: return Constants.sectionDownIcon
            case .open: return  Constants.sectionUpIcon
            }
        }
    }
}
