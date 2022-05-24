//
//  WordPair.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

struct WordPair: Codable, Hashable {
    let englishText: String
    let spanishText: String
    
    private enum CodingKeys: String, CodingKey {
        case englishText = "text_eng"
        case spanishText = "text_spa"
    }
}
