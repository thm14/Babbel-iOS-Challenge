//
//  NibView.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-22.
//

import UIKit

class NibView: UIView {
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func setupXib() {
        backgroundColor = UIColor.clear
        view = loadNib()
        view.frame = bounds
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
}
