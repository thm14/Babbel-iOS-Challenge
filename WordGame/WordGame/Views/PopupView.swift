//
//  PopupView.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-22.
//

import UIKit
import RxSwift

final class PopupView: NibView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var primaryTextLabel: UILabel!
    
    @IBOutlet weak var destructiveActionButton: UIButton!
    @IBOutlet weak var primaryActionButton: UIButton!
    
    private var presenter: PopupViewPresenter?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(presenter: PopupViewPresenter) {
        self.init()
        self.presenter = presenter
        setupUI()
        setupRxBindings()
    }
    
    private func setupUI() {
        containerView.makeRoundedCorner(with: 10)
        
        destructiveActionButton.setBackgroundColor(.red, for: .normal)
        destructiveActionButton.setBackgroundColor(.purple, for: .highlighted)
        destructiveActionButton.makeRoundedCorner()
        
        primaryActionButton.setBackgroundColor(.systemTeal, for: .normal)
        primaryActionButton.setBackgroundColor(.purple, for: .highlighted)
        primaryActionButton.makeRoundedCorner()
        
        primaryTextLabel.text = "\(presenter?.primaryText ?? "")"
    }
    
    private func setupRxBindings() {
        primaryActionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter?.primaryButtonTappedSignal.onNext(true)
            }).disposed(by: disposeBag)
        
        destructiveActionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter?.destructiveButtonTappedSignal.onNext(true)
            }).disposed(by: disposeBag)
    }
    
    func show() {
        self.addInUIApplicationKeyWindow()
        showViewWithTransition()
    }
    
    func hide() {
        self.removeFromSuperview()
    }
    
    private func showViewWithTransition() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
           let currentWindow = windowScene.windows.first else { return }
        containerView.center = CGPoint(x: currentWindow.center.x, y: -currentWindow.frame.size.height)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.containerView.center.y = currentWindow.center.y
            self.view.alpha = 0.9
        }, completion: nil)
    }
}
