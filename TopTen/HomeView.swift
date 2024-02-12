//
//  HomeView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/11.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Spacer(minLength:  geometry.size.height * 2/10)
                
                Text("TOP TEN GAME")
                    .padding()
                    .font(Font.custom("Selima", size: 40))
                    .foregroundColor(.blue)
                
                Spacer(minLength:  geometry.size.height * 6/10)
                
                Button (action: {
                    print("")
                }) {
                    Text("start")
                        .padding()
                        .font(.title2)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.1)
                }
                .border(Color.blue, width: 1)
                .background(Color.yellow)
                
                
                Spacer(minLength:  geometry.size.height * 1/10)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

#Preview {
    HomeView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
}
