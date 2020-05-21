//
//  UIView.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 19.0, -17.0, 15.0, -13.0, 10.0, -7.0, 3.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    var width: CGFloat {
        return self.frame.size.width
    }

    var height: CGFloat {
        return self.frame.size.height
    }

}
