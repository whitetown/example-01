//
//  LoginController.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginController: ScrollViewController {

    private let contentView = UIView()
    private let username    = UsernameField()
    private let password    = PasswordField()
    private let touchSwitch = TouchIDSwitch()
    
    private let lastusername = "lastusername"
    private let useTouchID   = "useTouchID"

    struct FormData {
        var username = ""
        var password = ""
        var touchID  = false
    }
    
    private var form = FormData()
    
    deinit {
        unsubscribeFromKeyboardEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        subscribeToKeyboardEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if  SecureManager.retrievePassword(login: self.useTouchID) != nil
            && self.form.username.count > 0 {
            displayTouchID()
        }
    }

    override func onKeyboardChange(_ height: CGFloat) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
    }
    
    public func checkTouchID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //enabled
        } else {
            self.touchSwitch.value = false
            self.form.touchID = false
            let ac = UIAlertController(title: "Touch ID not available",
                                       message: "Your device is not configured for Touch ID.",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}

private extension LoginController {
    
    func initialize() {
        self.view.backgroundColor = UIColor.backgroundColor
        restoreUsername()
        initContentView()
        initUsername()
        initPassword()
        initTouchControl()
    }
    
    func initContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view)
            make.height.greaterThanOrEqualTo(self.view)
        }
    }
    
    func initUsername() {
        self.contentView.addSubview(self.username)
        self.username.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-88)
            make.height.equalTo(44)
        }
        self.username.text = self.form.username
        self.username.onTextChange = { [weak self] text in
            self?.form.username = text
        }
        self.username.onReturn = { [weak self] in
            self?.password.becomeFirstResponder()
        }
    }
    
    func initPassword() {
        self.contentView.addSubview(self.password)
        self.password.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.username.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        self.password.text = self.form.password
        self.password.onTextChange = { [weak self] text in
            self?.form.password = text
        }
        self.password.onReturn = { [weak self] in
            self?.password.resignFirstResponder()
            self?.login()
        }
    }
    
    func initTouchControl() {
        self.contentView.addSubview(self.touchSwitch)
        self.touchSwitch.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.password.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        self.touchSwitch.value = self.form.touchID
        self.touchSwitch.onChange = { [weak self] value in
            self?.form.touchID = value
            self?.checkTouchID()
        }
    }
    
    func restoreUsername() {
        if let username = SecureManager.retrievePassword(login: self.lastusername) {
            self.form.username = username
        }
    }
    
    func displayTouchID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.loginWithTouchID()
                    } else {
                        let ac = UIAlertController(title: "Error",
                                                   message: "Authentication failed",
                                                   preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {

        }
    }
    
    func loginWithTouchID() {
        if let password = SecureManager.retrievePassword(login: self.form.username) {
            self.form.touchID  = true
            self.form.password = password
            login()
        } else {
            let ac = UIAlertController(title: "Error",
                                       message: "Password for user \(self.form.username) not found.",
                preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func login() {
        
        let isValid = Mock.credentials[self.form.username] == self.form.password
        if !isValid {
            self.username.shake()
            self.password.shake()
            return
        }
        
        if let previoususername = SecureManager.retrievePassword(login: self.lastusername) {
            if self.form.username != previoususername {
                _ = SecureManager.deleteLogin(login: previoususername)
            }
        }
        _ = SecureManager.deleteLogin(login: self.lastusername)
        _ = SecureManager.storeLogin(login: self.lastusername, password: self.form.username)

        if self.form.touchID {
            _ = SecureManager.storeLogin(login: self.form.username, password: self.form.password)
            _ = SecureManager.storeLogin(login: self.useTouchID, password: "true")
        } else {
            _ = SecureManager.deleteLogin(login: self.form.username)
            _ = SecureManager.deleteLogin(login: self.useTouchID)
        }
        
        openMovies()
    }
    
    func openMovies() {
        let vc = MoviesViewController()
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
}

/*
                 
 //        self.contentView.translatesAutoresizingMaskIntoConstraints = false
 //        self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
 //        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
 //        self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
 //        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
 //        self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
 //        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
         
         
 //        self.username.translatesAutoresizingMaskIntoConstraints = false
 //        self.username.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
 //        self.username.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
 //        self.username.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -54).isActive = true
 //        self.username.heightAnchor.constraint(equalToConstant: 44).isActive = true


 //        self.password.translatesAutoresizingMaskIntoConstraints = false
 //        self.password.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
 //        self.password.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
 //        self.password.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 20).isActive = true
 //        self.password.heightAnchor.constraint(equalToConstant: 44).isActive = true

 //        self.touchSwitch.translatesAutoresizingMaskIntoConstraints = false
 //        self.touchSwitch.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
 //        self.touchSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
 //        self.touchSwitch.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 20).isActive = true
 //        self.touchSwitch.heightAnchor.constraint(equalToConstant: 44).isActive = true

*/
