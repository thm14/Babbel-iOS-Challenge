//
//  GameEngineTests.swift
//  WordGameTests
//
//  Created by Mahesh De Silva on 2022-05-22.
//

import XCTest
@testable import WordGame

class GameEngineTests: XCTestCase {
    
    private var fileLoader: FileLoader!
    private var mockFileName: String!
    private var gameEngine: GameEngineProtocol!
    private var incorrectWordPair: WordPair!
    private var correctWordPair: WordPair!

    override func setUp(){
        self.fileLoader = FileLoader.shared
        self.gameEngine = GameEngine(fileLoader: self.fileLoader, fileName: "mock_correct_wordpair")
        self.incorrectWordPair = WordPair(englishText: "primary school", spanishText: "hola!")
        self.correctWordPair = GameEngine(fileLoader: self.fileLoader, fileName: "mock_correct_wordpair").wordPairs?.first
    }
    
    func testFetchNextWordPair_isNotNil() {
        self.gameEngine = GameEngine(fileLoader: self.fileLoader, fileName: "mock_wordpairs")
        XCTAssertNotNil(gameEngine.fetchNextWordPair())
    }
    
    func testFetchNextWordPair_isNil() {
        self.gameEngine = GameEngine(fileLoader: self.fileLoader, fileName: "mock_corrupt_wordpair")
        let wordPair = self.gameEngine.fetchNextWordPair()
        XCTAssertEqual(wordPair, nil)
    }
    
    func testFetchRandomIncorrectWordPair_isTrue() {
        self.gameEngine = GameEngine(fileLoader: self.fileLoader, fileName: "mock_wordpairs")
        do {
            let wordPair = try XCTUnwrap(self.gameEngine.generateRandomIncorrectWordPair())
            XCTAssertEqual(false, self.gameEngine.isCorrect(wordPair: wordPair))
        } catch {
            XCTFail("random incorrect word pair is nil.")
        }
    }
    
    func testFetchRandomIncorrectWordPair_isFalse() {
        self.gameEngine = GameEngine(fileLoader: self.fileLoader, fileName: "mock_correct_wordpair")
        do {
            let wordPair = try XCTUnwrap(self.gameEngine.generateRandomIncorrectWordPair())
            XCTAssertEqual(true, self.gameEngine.isCorrect(wordPair: wordPair))
        } catch {
            XCTFail("random incorrect word pair is nil.")
        }
    }
    
    func testIsCorrectWordPair_returnTrue() {
        self.gameEngine = GameEngine(fileLoader: self.fileLoader, fileName: "mock_correct_wordpair")
        do {
            let wordPair = try XCTUnwrap(self.gameEngine.wordPairs?.first)
            XCTAssertEqual(self.gameEngine.isCorrect(wordPair: wordPair), true)
        } catch {
            XCTFail("correct word pair is nil.")
        }
    }
    
    func testIsCorrectWordPair_returnFalse() {
        self.gameEngine = GameEngine(fileLoader: self.fileLoader, fileName: "mock_correct_wordpair")
        XCTAssertEqual(self.gameEngine.isCorrect(wordPair: incorrectWordPair), false)
    }
    
    func testEvaluateAttempt_correctWordPair_And_Correct_UserSeelction_isSuccess() {
        let userSelection: Bool = true
        let evaluation = self.gameEngine.evaluate(wordPair: correctWordPair, userSelection: userSelection)
        XCTAssertEqual(true, evaluation)
    }
    
    func testEvaluateAttempt_correctWordPair_And_Incorrect_UserSeelction_isFalse() {
        let userSelection: Bool = false
        let evaluation = self.gameEngine.evaluate(wordPair: correctWordPair, userSelection: userSelection)
        XCTAssertEqual(false, evaluation)
    }
    
    func testEvaluateAttempt_incorrectWordPair_And_Correct_UserSeelction_isFalse() {
        let userSelection: Bool = true
        let evaluation = self.gameEngine.evaluate(wordPair: incorrectWordPair, userSelection: userSelection)
        XCTAssertEqual(false, evaluation)
    }
    
    func testEvaluateAttempt_incorrectWordPair_And_Incorrect_UserSeelction_isSuccess() {
        let userSelection: Bool = false
        let evaluation = self.gameEngine.evaluate(wordPair: incorrectWordPair, userSelection: userSelection)
        XCTAssertEqual(true, evaluation)
    }
    
    func testCalcFinalScore_5Correct_is33() {
        let correctAttempts = 5
        let maxAttempts = 15
        let score = self.gameEngine.calcFinalScore(correctAttemps: correctAttempts, maxAttempts: maxAttempts)
        XCTAssertEqual(score, 33)
    }
    
    func testCalcFinalScore_0Correct_is0() {
        let correctAttempts = 0
        let maxAttempts = 3
        let score = self.gameEngine.calcFinalScore(correctAttemps: correctAttempts, maxAttempts: maxAttempts)
        XCTAssertEqual(score, 0)
    }

}
