//
//  ViewExtension.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/18.
//

import UIKit
import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.endEditing(force)
            }
        }
    }
}
