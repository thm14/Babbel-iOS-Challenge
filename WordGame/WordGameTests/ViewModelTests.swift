//
//  ViewModelTests.swift
//  WordGameTests
//
//  Created by Mahesh De Silva on 2022-05-22.
//

import XCTest
import RxSwift
import RxTest
import RxRelay
import RxBlocking
@testable import WordGame

class ViewModelTests: XCTestCase {
    
    /*
     var gameEngine: GameEngineProtocol { get set }
     var englishText: PublishSubject<String> { get }
     var spanishTranslation: PublishSubject<String> { get }
     var correctAttempts: BehaviorRelay<Int> { get }
     var wrongAttempts: BehaviorRelay<Int> { get }
     var timer: Observable<Int>? { get set }
     var timeout: Int { get }
     var maxIncorrectAttemptsAllowed: Int { get }
     var maxWordPairsAllowed: Int { get }
     var shouldGameEnd: Bool { get }
     var countdownSignal: PublishSubject<Bool> { get }
     var gameOverSignal: PublishSubject<Int> { get }
     
     func startGame()
     func restartGame()
     func quitGame()
     func evalUserAttempt(isCorrect: Bool)
     */
    
    private var gameViewModel: GameViewPresentable!
    private var mockGameEngine: GameEngineProtocol!
    private var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        self.mockGameEngine = GameEngine(fileName: "mock_wordpairs")
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testInitViewModel() {
        gameViewModel = GameViewModel(gameEngine: self.mockGameEngine)
        XCTAssertNotNil(gameViewModel)
        XCTAssertEqual(gameViewModel.maxWordPairsAllowed, 15)
        XCTAssertEqual(gameViewModel.maxIncorrectAttemptsAllowed, 3)
        XCTAssertEqual(gameViewModel.timeout, 5)
        XCTAssertEqual(gameViewModel.correctAttempts.value, 0)
        XCTAssertEqual(gameViewModel.wrongAttempts.value, 0)
        XCTAssertEqual(gameViewModel.gameEngine.wordPairs?.count, 3)
    }
    
    func testEnglishTextAndSpanishTranslationSignals() {
        gameViewModel = GameViewModel(gameEngine: GameEngine(fileName: "mock_correct_wordpair"))
        XCTAssertNotNil(gameViewModel)
        let englishTextSignal = gameViewModel.englishText.subscribe(on: scheduler)
        let spanishTranslationSignal = gameViewModel.spanishTranslation.subscribe(on: scheduler)
        gameViewModel.startGame()
        
        do {
            let englishSignal = try XCTUnwrap(englishTextSignal.toBlocking(timeout:7).first())
            let spanishSignal = try XCTUnwrap(spanishTranslationSignal.toBlocking(timeout:7).first())
            let wordPair: WordPair = try XCTUnwrap(gameViewModel.gameEngine.wordPairs?.first)
            XCTAssertEqual(englishSignal, wordPair.englishText)
            XCTAssertEqual(spanishSignal, wordPair.spanishText)
        } catch {
            XCTFail("exception occured.")
        }
    }
    
    func testCorrectAttemptAndWrongAttemptCount_when_userSelectionisCorrect() {
        gameViewModel = GameViewModel(gameEngine: GameEngine(fileName: "mock_correct_wordpair"))
        gameViewModel.startGame()
        let correctAttemptSignal = gameViewModel.correctAttempts.subscribe(on: scheduler)
        let wrongAttemptSignal = gameViewModel.wrongAttempts.subscribe(on: scheduler)
        gameViewModel.evalUserAttempt(isCorrect: true)
        do {
            let correctSignal = try XCTUnwrap(correctAttemptSignal.toBlocking(timeout:5).first())
            let wrongSignal = try XCTUnwrap(wrongAttemptSignal.toBlocking(timeout:5).first())
            XCTAssertEqual(correctSignal, 1)
            XCTAssertEqual(wrongSignal, 0)
        } catch {
            XCTFail("exception occured.")
        }
    }
    
    func testCorrectAttemptAndWrongAttemptCount_when_userSelectionisWrong() {
        gameViewModel = GameViewModel(gameEngine:  GameEngine(fileName: "mock_incorrect_wordpair"))
        gameViewModel.startGame()
        let correctAttemptSignal = gameViewModel.correctAttempts.subscribe(on: scheduler)
        let wrongAttemptSignal = gameViewModel.wrongAttempts.subscribe(on: scheduler)
        gameViewModel.evalUserAttempt(isCorrect: false)
        do {
            let correctSignal = try XCTUnwrap(correctAttemptSignal.toBlocking(timeout:5).first())
            let wrongSignal = try XCTUnwrap(wrongAttemptSignal.toBlocking(timeout:5).first())
            XCTAssertEqual(correctSignal, 0)
            XCTAssertEqual(wrongSignal, 1)
        } catch {
            XCTFail("exception occured.")
        }
    }
}
