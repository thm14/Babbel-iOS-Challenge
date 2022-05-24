//
//  Coordinator.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-21.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
