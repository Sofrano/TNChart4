//
//  GenericTableSheet.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 21.05.2021.
//

import Foundation
import SnapKit
import UIKit

class GenericTableSheet<T: Equatable>: SheetController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI Variables
    
    private lazy var tableView: IntrinsicSizeTableView = {
        let tableView = IntrinsicSizeTableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear//Theme.x.s.xxPickerBackgroundColor
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(SheetTextCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
        containerView.addSubview(tableView)
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    // MARK: - Variables
    public var onSelectValue: ((T) -> Void)?
    private var value: T?
    private var options: [T] = []
    private var footerText: String?
    private var closureValueFor: ((T) -> String)?
    
    // MARK: - Constructors
    
    init(with options: [T],
         title: String? = nil,
         value: T? = nil,
         footerText: String? = nil,
         valueFor: @escaping(T) -> String) {
        super.init()
        self.options = options
        self.value = value
        self.footerText = footerText
        self.closureValueFor = valueFor
        tableView.reloadData()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.text = footerText
        myLabel.font = TNChartConfiguration.chartAppearance.sheet.tableFooterViewTitleTextFont
        myLabel.textColor = TNChartConfiguration.chartAppearance.sheet.tableFooterViewTitleTextColor
        let headerView = UIView()
        headerView.addSubview(myLabel)
        myLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        headerView.backgroundColor = TNChartConfiguration.chartAppearance.sheet.tableHeaderBackgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if options[indexPath.row] == value {
            cell.setSelected(true, animated: true)
            cell.accessoryType = .checkmark
        }
        (cell as? SheetTextCell)?.valueLabel.text = closureValueFor?(options[indexPath.row])
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        cell.backgroundColor = .clear//Theme.x.s.lightColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        cell?.accessoryType = .checkmark
        
        if let selectedIndex = options.firstIndex(where: { $0 == value }) {
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
        }
        
        value = options[indexPath.row]
        guard let value = value else { return }
        onSelectValue?(value)
        close()
    }
    
}
