//
//  BaseViewController.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var keyboardHeight: CGFloat = 0 {
        didSet {
            onKeyboardChange(self.keyboardHeight)
        }
    }
    
    func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }

    func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object:nil)
    }

    @objc func keyboardDidShow(_ notification: Notification) {
        getKeyboardHeightFromNotification(notification)
    }

    @objc func keyboardDidHide(_ notification: Notification) {
        getKeyboardHeightFromNotification(notification)
    }

    @objc func keyboardDidChangeFrame(_ notification: Notification) {
        getKeyboardHeightFromNotification(notification)
    }

    @discardableResult func getKeyboardHeightFromNotification(_ notification: Notification) -> CGFloat {
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.keyboardHeight = max(0, self.view.height + self.view.frame.origin.y - targetFrame.minY)
        return self.keyboardHeight
    }

    func onKeyboardChange(_ height: CGFloat) {

    }


}
