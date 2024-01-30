//
//  ContentView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/01/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(ModelData())
    }
}
