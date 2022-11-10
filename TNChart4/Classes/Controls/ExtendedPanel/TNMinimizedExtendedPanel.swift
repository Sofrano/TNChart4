//
//  TNExtendedPanel.swift
//  Alamofire
//
//  Created by Dmitriy Safarov on 19.10.2022.
//

import Foundation
import UIKit

public protocol TNMinimizedExtendedPanelDelegate: AnyObject {
    func didClickChartType(_ panel: TNMinimizedExtendedPanel)
}

public class TNMinimizedExtendedPanel: UIView {
    
    // MARK: - Variables
    public weak var panelDelegate: TNMinimizedExtendedPanelDelegate?
    public weak var controllerDelegate: ChartControllerDelegate?
    private let vr = ViewResources()
    
    public var currentPeriod: TNChartPeriod {
        didSet {
            controllerDelegate?.onChangePeriod(currentPeriod)
            updateUI()
        }
    }
    
    public var currentChartType: TNChartType {
        didSet {
            controllerDelegate?.onChangeType(currentChartType)
            updateUI()
        }
    }
    
    // MARK: - Constructors
    
    public required init(period: TNChartPeriod = .day,
                         chartType: TNChartType = .bars) {
        self.currentPeriod = period
        self.currentChartType = chartType
        super.init(frame: .zero)
        initView()
        initConstraints()
        setupBindings()
        setupAppearance()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        vr.segmentedControl.selectValue(currentPeriod)
        addSubview(vr.segmentedControl)
        addSubview(vr.chartTypeButton)
    }
    
    private func initConstraints() {
        vr.segmentedControl.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        vr.chartTypeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(36.0)
            make.height.equalTo(32.0)
        }
        
    }
    
    // MARK: - Private Functions

    private func updateUI() {
        vr.chartTypeButton.setImage(currentChartType.icon, for: .normal)
    }
    
    private func setupAppearance() {
        let appearance = TNChartConfiguration.chartAppearance.newControl
        let buttons = [vr.chartTypeButton]
        for button in buttons {
            button.setTitleColor(appearance.buttonTitleColor, for: .normal)
            button.backgroundColor = appearance.buttonBackgroundColor
            button.titleLabel?.font = appearance.buttonFont
            button.layer.borderColor = appearance.buttonBorderColor.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 6.0
        }
    }
    
    private func setupBindings() {
        vr.segmentedControl.segmentedValueChanged = { [weak self] value in
            guard let self = self else { return }
            self.currentPeriod = value ?? .day
        }
        vr.chartTypeButton.addTarget(self, action: #selector(onChartTypeClick), for: .touchUpInside)
    }
    
    // MARK: - Objc Functions
    
    @objc
    private func onChartTypeClick() {
        panelDelegate?.didClickChartType(self)
    }
    
}

private class ViewResources {
    
    lazy var segmentedControl: EnumSegmentedControl<TNChartPeriod> = {
        let appearance = TNChartConfiguration.chartAppearance.newControl.segmentedControl
        let control = EnumSegmentedControl<TNChartPeriod>(appearance: appearance)
        return control
    }()
    
    lazy var chartTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = TNChartConfiguration.chartAppearance.control.chartTypeIconTintColor
        return button
    }()
    
}
