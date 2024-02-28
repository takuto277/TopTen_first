//
//  FeedbackView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/16.
//

import SwiftUI

struct FeedbackView<ViewModel: FeedbackViewModel>: View {
    @Binding var navigationPath: [NavigationPath]
    let randomNumber = Int.random(in: 1...10)
    @ObservedObject var viewModel: ViewModel
    @State private var text: String = ""
    @State private var isEditing = false
    @State private var pushNextButton = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("ゲームを遊んでくれてありがとう！\n今回の回答理由があれば教えてね")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    let data = viewModel.themeData.theme
                    Group {
                        Text("お題")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.horizontal, 10)
                        VStack(alignment: .center) {
                            Text(data.theme)
                                .font(.custom("STBaoliTC-Regular", size: 20))
                            Text(data.lowNumberTheme)
                                .foregroundColor(.red)
                            Text(data.highNumberTheme)
                                .foregroundColor(.green)
                        }
                        .frame(width: geometry.size.width * 0.9)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    Group {
                        Text("回答内容")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.horizontal, 10)
                        
                        if let myAnswer = viewModel.themeData.myAnswer {
                            HStack {
                                Text(myAnswer.answer)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10)
                                    .frame(width: geometry.size.width * 0.7)
                                    .frame(minWidth: geometry.size.width * 0.7, minHeight: geometry.size.height * 0.1, alignment: .center)
                                
                                Text(myAnswer.id)
                                    .font(.custom("STBaoliTC-Regular", size: 50))
                                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                                    .background(Color(red: 1.0 - Double(randomNumber) / 10.0, green: Double(randomNumber) / 10.0, blue: 0))
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    Group {

                            ZStack(alignment: .topLeading) {
                                textEditor
                                if text.isEmpty {
                                    placeholderText
                                }
                            }

                        
                        Button {
                            self.pushNextButton = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // アニメーションのdurationに合わせて設定
                                navigationPath.removeAll()
                            }
                        } label: {
                            Text("次へ")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.05)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding()
                
                Spacer()
            }
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
            .overlay {
                Color.black
                    .opacity(pushNextButton ? 1 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .animation(
                        Animation.spring(duration: TimeInterval(3)),
                        value: self.pushNextButton)
            }
            .onTapGesture {
                self.endEditing(true)
            }
        }
    }
    
    var placeholderText: some View {
        Text("今回の回答理由があれば記入をお願いします。\n他プレイヤーの出題回答に使用させていただきます。")
            .foregroundColor(Color(uiColor: .placeholderText))
            .padding(.vertical, 8)
            .allowsHitTesting(false)
    }
    
    var textEditor: some View {
        TextEditor(text: $text)
            .cornerRadius(10.0)
            .padding(.horizontal, -4)
            .frame(height: 150)
            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

struct Feedback_Previews: PreviewProvider {
    static let previewsThemeData = ThemeData(
        id: "1",
        theme: Theme(id: "1", theme: "ゾンビの世界で生き残れる隠れ場所", lowNumberTheme: "生き残れない場所", highNumberTheme: "生き残れる場所"),
        otherThemeAnswers: [Answer(id: "1", answer: "アンブレラ社", number: "9", reason: nil),
                            Answer(id: "1", answer: "空き家", number: "4", reason: nil),
                            Answer(id: "1", answer: "研究室", number: "3", reason: nil)],
        myAnswer: Answer(id: "1", answer: "これは私の回答で[病院]", number: "2", reason: nil))
    static var previews: some View {
        @State var navigationPath: [NavigationPath] = []
        FeedbackView(navigationPath: $navigationPath, viewModel: FeedbackViewModel(themeData: previewsThemeData))
    }
}
