//
//  HomeView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/11.
//

import SwiftUI

struct HomeView: View {
    @State private var isButtonVisible = true
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    RainAnimationView()
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
                                .opacity(isButtonVisible ? 1 : 0)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        isButtonVisible.toggle()
                                    }
                                }
                        }
                        .buttonStyle(MyButtonStyle())
                    
                    
                    Spacer(minLength:  geometry.size.height * 1/10)
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
            .onDisappear {
                isButtonVisible = true
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

struct NextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(configuration.isPressed ? Color.white : Color.red)
            .cornerRadius(10)
    }
}

struct RainAnimationView: View {
    @State private var raindrops: [Raindrop] = []
    let raindropCount = 100
    
    var body: some View {
        ZStack {
            ForEach(raindrops.indices, id: \.self) { index in
                let raindrop = raindrops[index]
                Circle()
                    .fill(Color.blue)
                    .frame(width: raindrop.size, height: raindrop.size)
                    .position(raindrop.position)
                    .animation(.easeInOut(duration: 3).repeatForever(), value: raindrops)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                            raindrops[index].position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                                                y: UIScreen.main.bounds.height)
                        }
                    }
            }
        }
        .onAppear {
            generateRaindrops()
        }
    }
    
    private func generateRaindrops() {
        for _ in 0..<raindropCount {
            let size = CGFloat.random(in: 2...4)
            let position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                   y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
            let raindrop = Raindrop(size: size, position: position)
            raindrops.append(raindrop)
        }
    }
}

struct Raindrop: Equatable {
    var size: CGFloat
    var position: CGPoint
    
    static func == (lhs: Raindrop, rhs: Raindrop) -> Bool {
        return lhs.size == rhs.size && lhs.position == rhs.position
    }
}


