//
//  MainTableView.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import UIKit

class MainTableView: UITableView {
    public var didSelect: Completion<MainInnerItemCell.Data>?
    
    private var sections: [Section] = []
    private var cellHeightCache = [IndexPath: CGFloat]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        dataSource = self
        delegate = self
        registerCell(MainItemCell.self)
        registerCell(MainInnerItemCell.self)
    }

    public func update(with sections: [Section]) {
        self.sections = sections
        reloadData()
    }

    private func didSelect(state: MainItemCell.State, indexPaths: [IndexPath], indexPath: IndexPath) {
        let newState = state.opposite
        sections[indexPath.section].update(state: newState)

        switch newState {
        case .close:
            deleteRows(at: indexPaths, with: .none)
        case .open:
            insertRows(at: indexPaths, with: .none)
        }
        reloadRows(at: [indexPath], with: .fade)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = sections[safe: section]?.rows.count ?? 0
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sections[safe: indexPath.section], let type = section.rows[safe: indexPath.row] else { fatalError() }
        switch type {
        case let .head(model):
            let cell: MainItemCell = tableView.dequeueReusableCell(indexPath)
            cell.update(with: model)
            return cell
        case let .inner(model):
            let cell: MainInnerItemCell = tableView.dequeueReusableCell(indexPath)
            cell.update(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = sections[safe: indexPath.section], let type = section.rows[safe: indexPath.row] else { return }
        switch type {
        case let .head(data):
            let indexPaths = section.indexPaths(with: indexPath.section)
            didSelect(state: data.state, indexPaths: indexPaths, indexPath: indexPath)
        case let .inner(data):
            didSelect?(data)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightCache[indexPath] ?? Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightCache[indexPath] = cell.bounds.height
    }
}

// MARK: - Nested Type
extension MainTableView {
    struct Section {
        var rows: [Row] = []
        var allRows: [Row]
        
        init(allRows: [Row]) {
            self.allRows = allRows
            update(state: .close)
        }
        
        mutating func update(state: MainItemCell.State) {
            rows = allRows
            if case .close = state, let first = allRows.first {
                rows = [first]
            }
            rows[0].update(state)
        }
        
        func indexPaths(with section: Int) -> [IndexPath] {
            let temp = allRows.dropFirst()
            return temp.indices.map { IndexPath(row: $0, section: section) }
        }
    }
    
    enum Row {
        case head(data: MainItemCell.Data)
        case inner(data: MainInnerItemCell.Data)
        
        mutating func update(_ state: MainItemCell.State) {
            guard case var .head(data) = self else { return }
            data.state = state
            self = .head(data: data)
        }
    }
}
