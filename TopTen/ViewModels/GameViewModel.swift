//
//  GameViewModel.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/19.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var themeData: ThemeData
    @Published var rankedAnswer: [RankedAnswer] = []
    
    init(themeData: ThemeData) {
        self.themeData = themeData
        self.createRankedAnswer()
    }
    
    func createRankedAnswer() {
        let availableAnswers = self.themeData.otherThemeAnswers.filter { $0.number != self.themeData.myAnswer?.number }
        
        // ランダムに3つの回答を選択する
        let randomAnswers = availableAnswers.shuffled().prefix(3)
        
        var allAnswers = randomAnswers
        if let myAnswer = self.themeData.myAnswer {
            allAnswers.append(myAnswer)
        }
        
        let sortedAnswers = randomAnswers.sorted { Int($0.number) ?? 0 < Int($1.number) ?? 0 }
        
        // 回答に順位を紐付ける
        self.rankedAnswer = sortedAnswers.enumerated().map { (index, answer) in
            let isMyAnswer = answer.number == self.themeData.myAnswer?.number
            return RankedAnswer(answer: answer, rank: index + 1, myAnswerFlg: isMyAnswer)
        }
        
        self.rankedAnswer.shuffle()
    }
}
