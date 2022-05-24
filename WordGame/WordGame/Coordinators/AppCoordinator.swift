//
//  AppCoordinator.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

import UIKit

final class AppCoordinator: NSObject, Coordinator {
    private let window: UIWindow
    var childCoordinators: [Coordinator] = []
    private(set) var navigationController: UINavigationController
    
    init(with window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let wordsFileName: String = "words"
        let gameViewController = GameViewController(with: GameViewModel(gameEngine: GameEngine(fileName: wordsFileName)))
        window.rootViewController = gameViewController
        window.makeKeyAndVisible()
    }
}
