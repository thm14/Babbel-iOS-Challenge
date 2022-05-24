//
//  GameViewModel.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

import Foundation
import RxSwift
import RxRelay

protocol GameViewPresentable {
    var gameEngine: GameEngineProtocol { get set }
    var englishText: PublishRelay<String> { get }
    var spanishTranslation: PublishRelay<String> { get }
    var correctAttempts: BehaviorRelay<Int> { get }
    var wrongAttempts: BehaviorRelay<Int> { get }
    var timer: Observable<Int>? { get set }
    var timeout: Int { get }
    var maxIncorrectAttemptsAllowed: Int { get }
    var maxWordPairsAllowed: Int { get }
    var shouldGameEnd: Bool { get }
    var countdownSignal: PublishRelay<Bool> { get }
    var gameOverSignal: PublishRelay<Int> { get }
    
    func startGame()
    func restartGame()
    func quitGame()
    func evalUserAttempt(isCorrect: Bool)
    
}

final class GameViewModel: GameViewPresentable {
    
    private var disposeBag = DisposeBag()
    private var currentWordPair: WordPair?
    internal var gameEngine: GameEngineProtocol
    
    var correctAttempts: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var wrongAttempts: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var englishText: PublishRelay<String> = PublishRelay<String>()
    var spanishTranslation: PublishRelay<String> = PublishRelay<String>()
    var countdownSignal: PublishRelay<Bool> = PublishRelay<Bool>()
    var gameOverSignal: PublishRelay<Int> = PublishRelay<Int>()
    
    var timer: Observable<Int>?
    
    init(gameEngine: GameEngineProtocol) {
        self.gameEngine = gameEngine
    }
    
    func evalUserAttempt(isCorrect: Bool) {
        guard let currentWordPair = self.currentWordPair else { return }
        if gameEngine.evaluate(wordPair: currentWordPair, userSelection: isCorrect) {
            correctAttempts.accept(correctAttempts.value+1)
        } else {
            wrongAttempts.accept(wrongAttempts.value+1)
        }
        shouldGameEnd ? showGameOverMenu() : loadNextWordPair()
    }
    
    func startGame() {
        loadNextWordPair()
    }
    
    func restartGame() {
        correctAttempts.accept(0)
        wrongAttempts.accept(0)
        loadNextWordPair()
    }
    
    func quitGame() {
        exit(0)
    }
    
    //MARK: - Private Functions
    
    private func loadNextWordPair() {
        guard let currentWordPair = gameEngine.fetchNextWordPair() else { return }
        self.currentWordPair = currentWordPair
        englishText.accept(currentWordPair.englishText)
        spanishTranslation.accept(currentWordPair.spanishText)
        startCountdownTimer()
    }
    
    private func count(from: Int, to: Int = 0, completionHandler: (() -> Void)? = nil) -> Observable<Int> {
        return Observable<Int>
            .timer( .seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(from - to + 1)
            .map { from - $0 }
            .do(onCompleted: {
                completionHandler?()
            })
    }
    
    private func startCountdownTimer() {
        resetTimer()
        timer = count(from: timeout, completionHandler: { [weak self] in
            guard let self = self else { return }
            self.wrongAttempts.accept(self.wrongAttempts.value+1)
            self.shouldGameEnd ? self.showGameOverMenu() : self.loadNextWordPair()
        })
        
        timer?.subscribe(onNext: { [weak self] time in
            if time == self?.timeout { self?.countdownSignal.accept(true) }
        }).disposed(by: disposeBag)

    }
    
    private func resetTimer() {
        disposeBag = DisposeBag()
    }
    
    private func showGameOverMenu() {
        resetTimer()
        gameOverSignal.accept(gameEngine.calcFinalScore(correctAttemps: correctAttempts.value,
                                             maxAttempts: maxWordPairsAllowed))
    }
}

extension GameViewModel {
    var maxWordPairsAllowed: Int { return 15 }
    var maxIncorrectAttemptsAllowed: Int { return 3 }
    
    var shouldGameEnd: Bool {
        return wrongAttempts.value >= maxIncorrectAttemptsAllowed ||
            correctAttempts.value+wrongAttempts.value >= maxWordPairsAllowed
    }
    
    var timeout: Int {
        return 5
    }
}
