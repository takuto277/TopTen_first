//
//  AsignNumberAnswerViewModel.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/18.
//

import Foundation

final class AsignNumberAnswerViewModel: ObservableObject {
    @Published var themeData: ThemeData
    var randomNumber = 0
    
    init(themeData: ThemeData) {
        self.themeData = themeData
        self.generateRandomNumber()
    }
    
    func generateRandomNumber() {
        self.randomNumber = Int.random(in: 1...10)
    }
    
    func setMyAnswer(answer: String) {
        let myAnswer = Answer(id: self.themeData.id, answer: answer, number: String(self.randomNumber), reason: nil)
        self.themeData.myAnswer = myAnswer
    }
}
