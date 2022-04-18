//
//  ChartPanel.swift
//  terminal
//
//  Created by Dmitriy Safarov on 17.02.2021.
//

import Foundation
import SnapKit
import UIKit

public protocol TNChartFullscreenPanelDelegate: AnyObject {
    func chartPanel(_ panel: TNChartFullscreenPanel, didChangePeriod period: TNChartPeriod)
    func chartPanel(_ panel: TNChartFullscreenPanel, didChangeChartType type: TNChartType)
    func chartPanel(_ panel: TNChartFullscreenPanel, didChangeChartRenderer renderer: TNChartRenderer)
    func didClosePanel(_ panel: TNChartFullscreenPanel)
}

public class TNChartFullscreenPanel: UIView {
    
    private lazy var chartTypeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(onChangeType), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var chartPeriodButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(onChangePeriod), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var chartRendererButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(onChangeRenderer), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var closeChartButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14
        button.setImage(closeChartImage, for: .normal)
        button.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        addSubview(stackView)
        return stackView
    }()
    
    // MARK: - Variables
    
    public weak var delegate: TNChartFullscreenPanelDelegate?
    
    private var mapPeriodButtons: [TNChartPeriod: UIButton] = [:]
    private var chartType: TNChartType
    private var chartPeriod: TNChartPeriod
    private var chartRenderer: TNChartRenderer = .native
    private let appearance: TNChartFullscreenPanelAppearancable
    private let closeChartImage: UIImage?
    private weak var targetViewController: UIViewController!
    
    // MARK: - Constructors
    
    public init(targetViewController: UIViewController,
         period: TNChartPeriod = .day,
         type: TNChartType) {
        self.appearance = TNChartConfiguration.chartAppearance.panel
        chartType = type
        chartPeriod = period
        self.closeChartImage = TNChartConfiguration.imageResources.chartPanelClose
        self.targetViewController = targetViewController
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        updateTypeButton(for: chartType)
        chartRendererButton.setTitle(chartRenderer.next.title, for: .normal)
        themeView()
        setPeriod(period)
        //updatePeriodButtons(withSelectedButton: periodButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        [chartPeriodButton, chartTypeButton, chartRendererButton].forEach { leftStackView.addArrangedSubview($0) }
        [closeChartButton].forEach { rightStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        leftStackView.snp.makeConstraints { (make) in
            make.leading.height.centerY.equalToSuperview()
        }
        rightStackView.snp.makeConstraints { (make) in
            make.trailing.height.centerY.equalToSuperview()
        }
    }
    
    private func themeView() {
        [chartTypeButton, chartRendererButton, closeChartButton, chartPeriodButton]
            .forEach { (button) in
                button.layer.cornerRadius = 14
                button.backgroundColor = appearance.buttonsBackgroundColor
                button.snp.makeConstraints { (make) in
                    make.width.equalTo(50)
                }
            }
        chartRendererButton.setTitleColor(appearance.chartRendererButtonTitleColor, for: .normal)
        chartPeriodButton.setTitleColor(appearance.chartPeriodButtonTitleColor, for: .normal)
        chartRendererButton.titleLabel?.font = appearance.chartRendererButtonFont
        chartPeriodButton.titleLabel?.font = appearance.chartPeriodButtonFont
    }
    
    // MARK: - Public Functions
    
    public func setPeriod(_ period: TNChartPeriod) {
        chartPeriodButton.setTitle(period.title, for: .normal)
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
        button.snp.makeConstraints { (make) in
            make.width.equalTo(button.snp.height).multipliedBy(1.786)
        }
        return button
    }
    
    private func updateTypeButton(for chartType: TNChartType) {
        chartTypeButton.setImage(chartType.icon, for: .normal)
    }
    
    private func selectPeriodButton(_ button: UIButton) {
        button.setTitleColor(appearance.periodButtonActiveTitleColor, for: .normal)
        button.backgroundColor = appearance.periodButtonActiveBackgroundColor
    }
    
    private func deselectPeriodButton(_ button: UIButton) {
        button.backgroundColor = appearance.periodButtonDefaultBackgroundColor
        button.setTitleColor(appearance.periodButtonDefaultTitleColor, for: .normal)
    }
    
}

// MARK: - OBJC Functions

extension TNChartFullscreenPanel {

    @objc
    private func onChangeRenderer() {
        chartRenderer = chartRenderer == .native ? .js : .native
        delegate?.chartPanel(self, didChangeChartRenderer: chartRenderer)
        chartRendererButton.setTitle(chartRenderer.next.title, for: .normal)
    }
    
    @objc
    private func onClose() {
        delegate?.didClosePanel(self)
    }
    
    @objc
    private func onChangeType() {
        chartType = chartType.next
        delegate?.chartPanel(self, didChangeChartType: chartType)
        updateTypeButton(for: chartType)
    }
    
    @objc
    private func onChangePeriod() {
        let sheet = GenericTableSheet<TNChartPeriod>(with: TNChartPeriod.allCases,
                                                   value: chartPeriod,
                                                   valueFor: { item in
                                                    return item.title
                                                   })
        sheet.onSelectValue = { [weak self] period in
            guard let self = self else { return }
            self.delegate?.chartPanel(self, didChangePeriod: period)
            self.setPeriod(period)
        }

        targetViewController.present(sheet, animated: true)
    }
}
