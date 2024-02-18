//
//  GameViewModel.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/19.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var themeData: ThemeData
    
    init(themeData: ThemeData) {
        self.themeData = themeData
    }
}
