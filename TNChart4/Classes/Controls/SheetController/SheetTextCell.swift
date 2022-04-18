//
//  SheetTextCell.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 21.05.2021.
//

import Foundation
import SnapKit
import UIKit

class SheetTextCell: UITableViewCell {
    
    // MARK: - UI Variables
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        addSubview(view)
        TNChartConfiguration.chartAppearance.sheet.setupCellSeparator(view)
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = TNChartConfiguration.chartAppearance.sheet.cellTextFont
        label.textColor = TNChartConfiguration.chartAppearance.sheet.cellTextColor
        addSubview(label)
        return label
    }()
    
    // MARK: - Constructors
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setupConstraints() {
        separatorView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.bottom.trailing.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { (make) in
            var spacing = 16
            let currentOrientation = UIDevice.current.orientation
            spacing = currentOrientation == .landscapeRight ? 32 : spacing
            spacing = currentOrientation == .landscapeLeft ? 64 : spacing
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(spacing)
        }
    }
    
}
