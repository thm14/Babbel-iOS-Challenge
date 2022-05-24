//
//  UIButton+Extension.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
  }
    
}

