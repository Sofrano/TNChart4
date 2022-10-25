//
//  HVStackView.swift
//  TNChart4
//
//  Created by Dmitriy Safarov on 20.10.2022.
//

import Foundation

class HStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fill
        spacing = 16.0
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

class VStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fill
        spacing = 16.0
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
