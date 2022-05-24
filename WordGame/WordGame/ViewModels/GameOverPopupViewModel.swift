//
//  GameOverPopupViewModel.swift
//  WordGame
//
//  Created by Mahesh De Silva on 2022-05-22.
//

import RxSwift
import RxRelay

protocol PopupViewPresenter {
    var primaryText: String { get }
    var primaryButtonTappedSignal: PublishSubject<Bool> { get set }
    var destructiveButtonTappedSignal: PublishSubject<Bool> { get set }
}

struct GameOverPopupViewModel: PopupViewPresenter {
    var primaryButtonTappedSignal: PublishSubject<Bool> = PublishSubject<Bool>()
    var destructiveButtonTappedSignal: PublishSubject<Bool> = PublishSubject<Bool>()
    
    var primaryText: String { return "\(score)%" }
    private var score: Int
    
    init(with score: Int) {
        self.score = score
    }

}
