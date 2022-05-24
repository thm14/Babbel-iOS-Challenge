//
//  GameEngine.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

import Foundation

protocol GameEngineProtocol {
    var wordPairs: [WordPair]? { get }
    var fileLoader: FileLoaderProtocol { get set }
    var fileName: String { get set }
    
    func fetchNextWordPair() -> WordPair?
    func generateRandomIncorrectWordPair() -> WordPair?
    func generateRandomCorrectWordPair() -> WordPair?
    func isCorrect(wordPair: WordPair) -> Bool
    func evaluate(wordPair: WordPair, userSelection: Bool) -> Bool
    func calcFinalScore(correctAttemps: Int, maxAttempts: Int) -> Int
}

final class GameEngine: GameEngineProtocol {
    
    private var wordPairsDict: [String: String]
    internal var fileName: String
    var wordPairs: [WordPair]?
    var fileLoader: FileLoaderProtocol
    
    init(fileLoader: FileLoaderProtocol = FileLoader.shared,
         fileName: String) {
        self.fileLoader = fileLoader
        self.fileName = fileName
        let wordPairs = fileLoader.loadData(type: [WordPair].self, from: fileName)
        self.wordPairs =  Array(Set(wordPairs ?? []))
        
        let englishWords = self.wordPairs?.map {$0.englishText} ?? []
        let spanishWords = self.wordPairs?.map {$0.spanishText} ?? []
        self.wordPairsDict = Dictionary(uniqueKeysWithValues: zip(englishWords, spanishWords))
    }
    
    internal func generateRandomIncorrectWordPair() -> WordPair? {
        guard let shuffledWords = self.wordPairs?.shuffled(),
              let englishText = shuffledWords.randomElement()?.englishText,
              let spanishText = shuffledWords.shuffled().randomElement()?.spanishText else {
            return nil
        }
        return WordPair(englishText: englishText, spanishText: spanishText)
    }
    
    internal func generateRandomCorrectWordPair() -> WordPair? {
        return self.wordPairs?.randomElement()
    }
    
    func fetchNextWordPair() -> WordPair? {
        if arc4random_uniform(4) == 1 {
            return generateRandomCorrectWordPair()
        } else {
            return generateRandomIncorrectWordPair()
        }
    }
    
    func isCorrect(wordPair: WordPair) -> Bool {
        return wordPairsDict[wordPair.englishText] == wordPair.spanishText
    }
    
    func evaluate(wordPair: WordPair, userSelection: Bool) -> Bool {
        let isCorrectTranslation = isCorrect(wordPair: wordPair)
        return (isCorrectTranslation && userSelection) == true ||
                (isCorrectTranslation == false) && (userSelection == false)
    }
    
    func calcFinalScore(correctAttemps: Int, maxAttempts: Int) -> Int {
        let correctAttempts = Double(correctAttemps)
        let totalAttempts = Double(maxAttempts)
        
        if totalAttempts == 0 { return 0 }
        let score = (correctAttempts/totalAttempts)*100
        return Int(score)
    }
    
}
