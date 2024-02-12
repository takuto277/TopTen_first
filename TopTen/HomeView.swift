//
//  HomeView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/11.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    Spacer(minLength:  geometry.size.height * 2/10)
                    
                    Text("TOP TEN GAME")
                        .padding()
                        .font(.custom("AcademyEngravedLetPlain", size: 40))
                        .foregroundColor(.blue)
                    
                    Spacer(minLength:  geometry.size.height * 6/10)
                    
                    
                    NavigationLink(destination: SelectThemeView()
                        .navigationBarBackButtonHidden(true)) {
                        Text("START")
                            .padding()
                            .font(.custom("STBaoliTC-Regular", size: 30))
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.03)
                    }
                    .buttonStyle(MyButtonStyle())

                    Spacer(minLength:  geometry.size.height * 1/10)
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
        }
    }
}

#Preview {
    HomeView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
}

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.yellow)
            .foregroundColor(configuration.isPressed ? Color.gray : Color.blue)
            .cornerRadius(10)
    }
}

struct BackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray)
            .foregroundColor(configuration.isPressed ? Color.white : Color.blue)
            .cornerRadius(10)
    }
}
