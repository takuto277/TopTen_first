//
//  FeedbackViewModel.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/28.
//

import Foundation

final class FeedbackViewModel: ObservableObject {
    @Published var themeData: ThemeData
    
    init(themeData: ThemeData) {
        self.themeData = themeData
    }
    
    func setReason(text: String?) {
        if let text = text, !text.isEmpty {
            self.themeData.myAnswer?.reason = text
        }
    }
}
