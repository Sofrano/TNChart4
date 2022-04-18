//
//  ChartController.swift
//  terminal
//
//  Created by Dmitriy Safarov on 10.02.2021.
//

import Foundation
import SnapKit
import UIKit

public protocol ChartControllerDelegate: AnyObject {
    func onChangePeriod(_ period: TNChartPeriod)
    func onChangeType(_ type: TNChartType)
}

/// Period and chart type controller
/// Used in minimized chart mode, below the chart
public class TNChartMinimizedPanel: UIView {
    
    // MARK: - UI Variables
    
    private lazy var chartTypeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(onChangeType), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        addSubview(stackView)
        return stackView
    }()
    
    // MARK: - Variables
    public weak var delegate: ChartControllerDelegate?
    private var mapPeriodButtons: [TNChartPeriod: UIButton] = [:]
    private var chartType: TNChartType
    
    // MARK: - Constructors
    
    public init(period: TNChartPeriod = .day, type: TNChartType) {
        chartType = type
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        themeView()
        guard let periodButton = mapPeriodButtons[period] else { return }
        updatePeriodButtons(withSelectedButton: periodButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        TNChartPeriod.allCases.forEach { (type) in
            let periodButton = buildButton(for: type)
            mapPeriodButtons[type] = periodButton
            stackView.addArrangedSubview(periodButton)
        }
    }
    
    private func setupConstraints() {
        chartTypeButton.snp.makeConstraints { (make) in
            make.trailing.top.height.equalToSuperview()
            make.width.equalTo(chartTypeButton.snp.height).multipliedBy(1.786)
        }
        stackView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualTo(chartTypeButton.snp.leading).offset(-16)
        }
    }
    
    private func themeView() {
        chartTypeButton.backgroundColor = TNChartConfiguration.chartAppearance.control.chartTypeBackgroundColor
        updateTypeButton(for: chartType)
        chartTypeButton.layer.cornerRadius = 14
        chartTypeButton.layer.borderWidth = 1
        chartTypeButton.layer.borderColor = TNChartConfiguration.chartAppearance.control.chartTypeBorderColor.cgColor
    }
    
    // MARK: - Public Functions
    
    public func setPeriod(_ period: TNChartPeriod) {
        guard let button = mapPeriodButtons[period] else { return }
        updatePeriodButtons(withSelectedButton: button)
    }
    
    public func setChartType(_ type: TNChartType) {
        chartType = type
        updateTypeButton(for: chartType)
    }
    
    // MARK: - Private Functions
    
    private func buildButton(for period: TNChartPeriod) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 14
        button.setTitle(period.title, for: .normal)
        button.tag = period.rawValue
        button.addTarget(self, action: #selector(onChangePeriod), for: .touchUpInside)
        button.titleLabel?.font = TNChartConfiguration.chartAppearance.control.periodButtonTitleFont
        button.snp.makeConstraints { (make) in
            make.width.equalTo(button.snp.height).multipliedBy(1.786)
        }
        return button
    }
    
    private func updatePeriodButtons(withSelectedButton selectedButton: UIButton) {
        stackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach { (arrangedButton) in
            selectedButton == arrangedButton
                ? selectPeriodButton(arrangedButton)
                : deselectPeriodButton(arrangedButton)
        }
    }
    
    private func updateTypeButton(for chartType: TNChartType) {
        chartTypeButton.setImage(chartType.icon, for: .normal)
    }
    
    private func selectPeriodButton(_ button: UIButton) {
        button.backgroundColor = TNChartConfiguration.chartAppearance.control.periodButtonActiveTitleColor
        button.setTitleColor(TNChartConfiguration.chartAppearance.control.periodButtonActiveBackgroundColor, for: .normal)
    }
    
    private func deselectPeriodButton(_ button: UIButton) {
        button.backgroundColor = TNChartConfiguration.chartAppearance.control.periodButtonDefaultTitleColor
        button.setTitleColor(TNChartConfiguration.chartAppearance.control.periodButtonDefaultBackgroundColor, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc
    private func onChangeType() {
        chartType = chartType.next
        delegate?.onChangeType(chartType)
        updateTypeButton(for: chartType)
    }
    
    @objc
    private func onChangePeriod(_ button: UIButton) {
        guard let period = TNChartPeriod(rawValue: button.tag) else { return }
        delegate?.onChangePeriod(period)
        updatePeriodButtons(withSelectedButton: button)
    }
    
}
