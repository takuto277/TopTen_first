//
//  HomeView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/11.
//

import SwiftUI

// 配列パスとして使う列挙型
enum NavigationPath: Hashable {
    
    case pathHome
    case pathSelectTheme
    case pathAsignNumber(ThemeData)
    case pathGame(ThemeData)
    case pathFeedBack(ThemeData)
}

struct HomeView: View {
    @State private var navigationPath: [NavigationPath] = []
    @State private var isButtonVisible = true
    @State private var animationFinished = false
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                VStack {
                    RainAnimationView()
                    Spacer(minLength:  geometry.size.height * 2/10)
                    
                    Text("TOP TEN GAME")
                        .padding()
                        .font(.custom("AcademyEngravedLetPlain", size: 40))
                        .foregroundColor(.blue)
                    
                    Spacer(minLength:  geometry.size.height * 6/10)
                    
                    Button {
                        navigationPath.append(.pathSelectTheme)
                    } label: {
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
                .overlay(
                    Color.black.opacity(!animationFinished ? 1 : 0)
                        .edgesIgnoringSafeArea(.all)
                        .animation(
                            Animation.spring(duration: TimeInterval(3)),
                            value: !animationFinished)
                        .allowsHitTesting(false)
                )
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // アニメーションのdurationに合わせて設定
                    self.animationFinished = true
                }
            }
            .onDisappear {
                isButtonVisible = true
                self.animationFinished = false
            }
            .navigationDestination(for: NavigationPath.self) { value in
                switch value {
                case .pathHome:
                    HomeView()
                case .pathSelectTheme:
                    SelectThemeView(navigationPath: $navigationPath, viewModel: SelectThemeViewModel())
                        .navigationBarBackButtonHidden(true)
                case .pathAsignNumber(let themeData):
                    AsignNumberAnswerView(navigationPath: $navigationPath, viewModel: AsignNumberAnswerViewModel(themeData: themeData))
                        .navigationBarBackButtonHidden(true)
                case .pathGame(let themeData):
                    GameView(navigationPath: $navigationPath, viewModel: GameViewModel(themeData: themeData))
                        .navigationBarBackButtonHidden(true)
                case .pathFeedBack(let themeData):
                    FeedbackView(navigationPath: $navigationPath, viewModel: FeedbackViewModel(themeData: themeData))
                        .navigationBarBackButtonHidden(true)
                }
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

struct MyDisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray)
            .foregroundColor(configuration.isPressed ? Color.white : Color.white)
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


