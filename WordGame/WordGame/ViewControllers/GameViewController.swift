//
//  GameViewController.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewController: UIViewController {
    
    @IBOutlet weak var correctAttemptsCounterLabel: UILabel!
    @IBOutlet weak var wrongAttemptsCounterLabel: UILabel!
    @IBOutlet weak var spanishTranslationLabel: UILabel!
    @IBOutlet weak var englishTranslationLabel: UILabel!
    
    @IBOutlet weak var wrongButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    
    @IBOutlet var spanishTranslationLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var spanishTranslationLabelBottomConstraint: NSLayoutConstraint!
    
    private var viewModel: GameViewPresentable
    private let disposeBag = DisposeBag()
    private var popup: PopupView?
    
    init(with viewModel: GameViewPresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayoutConstraints()
        setupRxBindings()
        viewModel.startGame()
    }
    
    private func setupUI() {
        wrongButton.setBackgroundColor(.red, for: .normal)
        wrongButton.setBackgroundColor(.purple, for: .highlighted)
        wrongButton.makeRoundedCorner()
        
        correctButton.setBackgroundColor(.systemOrange, for: .normal)
        correctButton.setBackgroundColor(.purple, for: .highlighted)
        correctButton.makeRoundedCorner()
        
    }
    
    private func setupLayoutConstraints() {
        spanishTranslationLabel.translatesAutoresizingMaskIntoConstraints = false
        spanishTranslationLabelTopConstraint.isActive = true
        spanishTranslationLabelBottomConstraint.isActive = false
    }
    
    private func setupRxBindings() {
        correctButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.resetLabelAnimation()
            self?.viewModel.evalUserAttempt(isCorrect: true)
        }).disposed(by: disposeBag)
        
        wrongButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.resetLabelAnimation()
            self?.viewModel.evalUserAttempt(isCorrect: false)
        }).disposed(by: disposeBag)
        
        viewModel.correctAttempts
            .map {"\(Strings.correctAttemptsLabelText) \($0)"}
            .bind(to: correctAttemptsCounterLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.wrongAttempts
            .map {"\(Strings.wrongAttemptsLabelText) \($0)"}
            .bind(to: wrongAttemptsCounterLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.englishText
            .bind(to: englishTranslationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.spanishTranslation
            .bind(to: spanishTranslationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.countdownSignal
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] hasCountdownBegun in
                if hasCountdownBegun {
                    self?.startLabelAnimation()
                }
        }).disposed(by: disposeBag)
        
        viewModel.gameOverSignal
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] score in
                self?.showWordLabels(false)
                self?.showGameOverPopup(with: score)
            }).disposed(by: disposeBag)
        
    }
    
    private func pinTranslationLabelToTop(_ shouldPin: Bool) {
        spanishTranslationLabelTopConstraint.isActive = shouldPin
        spanishTranslationLabelBottomConstraint.isActive = !shouldPin
    }
    
    private func startLabelAnimation() {
        pinTranslationLabelToTop(false)
        UIView.animate(withDuration: TimeInterval(viewModel.timeout), delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.spanishTranslationLabel.alpha = 0.1
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] finished in
            self?.pinTranslationLabelToTop(true)
            self?.spanishTranslationLabel.alpha = 1
        })
    }
    
    private func resetLabelAnimation() {
        self.spanishTranslationLabel.layer.removeAllAnimations()
        pinTranslationLabelToTop(true)
        view.layoutIfNeeded()
    }
    
    private func showWordLabels(_ show: Bool) {
        spanishTranslationLabel.isHidden = !show
        englishTranslationLabel.isHidden = !show
    }
    
    private func showGameOverPopup(with score: Int) {
        var presenter = GameOverPopupViewModel(with: score)
        attachPopupRxBindings(to: &presenter)
        popup = PopupView(presenter: presenter)
        popup?.frame = self.view.bounds
        popup?.show()
    }
    
    private func attachPopupRxBindings(to presenter: inout GameOverPopupViewModel) {
        presenter.primaryButtonTappedSignal
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tapped in
            self?.showWordLabels(true)
            self?.popup?.hide()
            self?.viewModel.restartGame()
        }).disposed(by: disposeBag)
        
        presenter.destructiveButtonTappedSignal
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tapped in
            self?.viewModel.quitGame()
        }).disposed(by: disposeBag)
        
    }
    
}
