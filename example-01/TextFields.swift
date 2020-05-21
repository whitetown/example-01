//
//  TextFields.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {

    public var onTextChange: ((String)->Void)?
    public var onFocus: (()->Void)?
    public var onBlur:  (()->Void)?
    public var onReturn: (()->Void)?

    internal var inactiveColor = UIColor.inactiveColor
    internal var activeColor   = UIColor.activeColor
    
    internal let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

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
        self.layer.borderWidth = 1
        self.layer.borderColor = self.inactiveColor.cgColor
        
        self.delegate = self
        
        self.addTarget(self, action: #selector(didChange(_:)), for: .allEditingEvents)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    @objc func didChange(_ textField: UITextField) {
        self.onTextChange?(self.text ?? "")
    }
    
}

extension BaseTextField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderColor = self.activeColor.cgColor
        self.onFocus?()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = self.inactiveColor.cgColor
        self.onBlur?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onReturn?()
        return true
    }
    
}

class UsernameField: BaseTextField {
    
    override func initialize() {
        super.initialize()
        self.placeholder = "Username".localized
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.returnKeyType = .next
    }
}

class PasswordField: BaseTextField {
    
    override func initialize() {
        super.initialize()
        self.placeholder = "Password".localized
        self.isSecureTextEntry = true
    }
}
