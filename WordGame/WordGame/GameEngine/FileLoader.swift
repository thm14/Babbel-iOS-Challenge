//
//  FileLoader.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

import Foundation

protocol FileLoaderProtocol {
    func loadData<T: Decodable>(type: T.Type, from fileName: String) -> T?
}

final class FileLoader: FileLoaderProtocol {
    
    static let shared = FileLoader()
    
    func loadData<T : Decodable>(type: T.Type, from fileName: String) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(type, from: data)
                return jsonData
            } catch {
                print("file loading error: \(error)")
            }
        }
        return nil
    }
    
    
}
