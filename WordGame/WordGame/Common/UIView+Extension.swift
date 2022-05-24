//
//  UIView+Extension.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-22.
//

import UIKit

extension UIView {

    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func addInUIApplicationKeyWindow() {
        let scenes = UIApplication.shared.connectedScenes
        if let windowScene = scenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(self)
        }
    }
    
    func makeRoundedCorner() {
        makeRoundedCorner(with: self.frame.size.height / 2.0)
        self.clipsToBounds = true
    }
    
    func makeRoundedCorner(with radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
