//
//  ThemeData.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/18.
//

import Foundation

// お題データ
struct ThemeData: Decodable, Hashable {
    let id: String
    let theme: Theme
    let otherThemeAnswers: [Answer]
    var myAnswer: Answer?
}

// お題
struct Theme: Decodable, Hashable {
    let id: String
    let theme: String
    let lowNumberTheme: String
    let highNumberTheme: String
}

/// 回答内容
struct Answer: Decodable, Hashable {
    let id: String
    let answer: String
    let number: String
    var reason: String?
}

struct RankedAnswer {
    let answer: Answer
    let rank: Int
    let myAnswerFlg: Bool
}
