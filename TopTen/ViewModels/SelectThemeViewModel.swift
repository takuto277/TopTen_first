//
//  SelectThemeViewModel.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/18.
//

import Foundation

final class SelectThemeViewModel: ObservableObject {
    @Published var data: [ThemeData] = []
    var resourceData: Data
    
    init(resourceData: Data) {
        self.resourceData = resourceData
        self.fetchData()
    }
    
    convenience init(){
        self.init(
            resourceData:
                try! Data(contentsOf: Bundle.main.url(forResource: "InitTheme", withExtension: "json")!))
    }
    
    func fetchData() {
        // データを取得する処理
        do {
            let decoder = JSONDecoder()
            self.data = try decoder.decode([ThemeData].self, from: self.resourceData)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
