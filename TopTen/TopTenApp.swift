//
//  TopTenApp.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/01/27.
//

import SwiftUI

@main
struct TopTenApp: App {
    @State private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
            
        }
    }
}
