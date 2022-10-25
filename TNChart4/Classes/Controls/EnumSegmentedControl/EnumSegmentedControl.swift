//
//  EnumSegmentedControl.swift
//  Alamofire
//
//  Created by Dmitriy Safarov on 20.10.2022.
//

import Foundation
import SnapKit
import UIKit

public protocol EnumSegmentedControlItemable: RawRepresentable, CaseIterable {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var localized: String { get }
}

public class EnumSegmentedControl<E: EnumSegmentedControlItemable>: UIView where E.RawValue == Int {
    
    // MARK: - Variables
    private let appearance: EnumSegmentedControlAppearancable
    private let vr = ViewResources<E>()
    var selectedSegmentedValue: E?
    var segmentedValueChanged: ((E?) -> Void)?
    
    private var buttons: [UIButton] {
        vr.hStackView.arrangedSubviews.compactMap { $0 as? UIButton }
    }
    
    // MARK: Constructors
    
    init(appearance: EnumSegmentedControlAppearancable) {
        self.appearance = appearance
        super.init(frame: .zero)
        initView()
        initConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        renderButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(vr.hStackView)
        E.allCases.forEach { type in
            let button = vr.makeButton(for: type)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            vr.hStackView.addArrangedSubview(button)
        }
        //renderButtons()
    }
    
    private func initConstraints() {
        vr.hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Functions
    
    func selectValue(_ value: E) {
        guard selectedSegmentedValue?.rawValue != value.rawValue else { return }
        selectedSegmentedValue = value
        buttons.forEach { deselectButton($0) }
        if let button = buttons.first(where: { $0.tag == value.rawValue }) {
            selectButton(button)
        }
    }
    
    // MARK: - Private Functions
    
    private func renderButtons() {
        let firstButton = vr.hStackView.arrangedSubviews.first as? UIButton
        for button in buttons {
            button.setTitleColor(appearance.buttonTitleColor, for: .normal)
            button.backgroundColor = appearance.buttonBackgroundColor
            button.titleLabel?.font = appearance.buttonFont
            button.layer.borderColor = appearance.buttonBorderColor.cgColor
            button.layer.borderWidth = 1.0
            if button.tag == selectedSegmentedValue?.rawValue {
                selectButton(button)
            }
        }
        
        firstButton?.roundCorners(corners: [.topLeft, .bottomLeft],
                                  radius: 6.0,
                                  borderColor: appearance.buttonBorderColor)

        let lastButton = vr.hStackView.arrangedSubviews.last as? UIButton
        lastButton?.roundCorners(corners: [.topRight, .bottomRight],
                                 radius: 6.0,
                                 borderColor: appearance.buttonBorderColor)
        
        vr.buttonDividers.forEach({
            $0.removeFromSuperview()
        })
        vr.buttonDividers = []
        
        for index in buttons.indices {
            let button = buttons[index]
            if index != 0 {
                let divider = UIView()
                divider.backgroundColor = appearance.buttonDividerColor
                vr.hStackView.addSubview(divider)
                divider.snp.makeConstraints { make in
                    make.width.equalTo(1.0)
                    make.height.equalTo(button.snp.height)
                    make.leading.equalTo(button.snp.leading)
                }
                vr.buttonDividers.append(divider)
            }
        }
    }
    
    private func selectButton(_ button: UIButton) {
        button.backgroundColor = appearance.buttonSelectedBackgroundColor
        button.setTitleColor(appearance.buttonTitleSelectedColor, for: .normal)
    }
    
    private func deselectButton(_ button: UIButton) {
        button.backgroundColor = appearance.buttonBackgroundColor
        button.setTitleColor(appearance.buttonTitleColor, for: .normal)
    }
    
    // MARK: OBJC Functions
    
    @objc
    private func buttonAction(_ sender: UIButton) {
        selectedSegmentedValue = E(rawValue: sender.tag)
        segmentedValueChanged?(selectedSegmentedValue)
        buttons.forEach { deselectButton($0) }
        selectButton(sender)
    }
    
}

extension EnumSegmentedControl {
    
   
}

private class ViewResources<E: EnumSegmentedControlItemable> where E.RawValue == Int {
    
    lazy var hStackView: HStackView = {
        let stackView = HStackView()
        stackView.spacing = -1.0
        return stackView
    }()
    
    var buttonDividers: [UIView] = []
    
    func makeButton(for type: E) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: type.width, height: type.height))
        button.snp.makeConstraints { make in
            make.width.equalTo(type.width)
            make.height.equalTo(type.height)
        }
        button.setTitle(type.localized, for: .normal)
        button.tag = type.rawValue
        
        return button
    }
    
}
