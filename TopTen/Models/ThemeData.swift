//
//  ThemeData.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/18.
//

import Foundation

struct ThemeData {
    let theme: Theme
    let otherThemeAnswers: [Answers]
}

struct Theme {
    let theme: String
    let lowNumberTheme: String
    let highNumberTheme: String
}

struct Answers {
    let id: String
    let answer: String
    let number: String
}
