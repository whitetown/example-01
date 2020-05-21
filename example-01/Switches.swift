//
//  Switches.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit
import SnapKit

class BaseSwitch: UIView {
    
    public var value = false {
        didSet {
            self.checkbox.setOn(self.value, animated: true)
        }
    }
    public var onChange: ((Bool)->Void)?
    
    internal let label     = UILabel()
    internal let checkbox  = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    internal func initialize() {
        self.layer.cornerRadius = 8
        
        self.addSubview(self.checkbox)
        self.checkbox.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        
        self.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.checkbox.snp.left).offset(-10)
        }
        
        self.checkbox.addTarget(self, action: #selector(onValueChange), for: .valueChanged)
    }
    
    @objc private func onValueChange() {
        self.onChange?(self.checkbox.isOn)
    }
    
}

class TouchIDSwitch: BaseSwitch {
    
    override func initialize() {
        super.initialize()
        
        self.backgroundColor = UIColor.lightColor

        self.label.text = "Enable Touch ID login".localized
    }
    
}
