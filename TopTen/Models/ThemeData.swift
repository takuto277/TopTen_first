//
//  ThemeData.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/18.
//

import Foundation

// お題データ
struct ThemeData: Decodable {
    let theme: Theme
    let otherThemeAnswers: [Answer]
}

// お題
struct Theme: Decodable {
    let id: String
    let theme: String
    let lowNumberTheme: String
    let highNumberTheme: String
}

/// 回答内容
struct Answer: Decodable {
    let id: String
    let answer: String
    let number: String
}
