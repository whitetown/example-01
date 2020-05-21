//
//  UIColor.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var backgroundColor: UIColor { return UIColor(named: "bgColor") ?? .white }
    static var activeColor:     UIColor { return UIColor(named: "activeColor") ?? .blue }
    static var inactiveColor:   UIColor { return UIColor(named: "inactiveColor") ?? .gray }
    static var lightColor:      UIColor { return UIColor(named: "lightColor") ?? .lightGray }

}
