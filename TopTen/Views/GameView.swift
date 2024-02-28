//
//  GameView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/13.
//

import SwiftUI

struct GameView<ViewModel: GameViewModel>: View {
    @Binding var navigationPath: [NavigationPath]
    @ObservedObject var viewModel: ViewModel
    @State private var isShowingPopup = false
    @State private var data = userAnswerData(answers: answers(), correctNumbers: correctNumbers())
    @State private var selectedButtonIndex: Int?
    @State private var pushDecideButton = false
    @State private var showCorrectNumber = false
    @State private var animationFinished = false
    @State private var isPressed = false
    @State private var pressedIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack (spacing: 20){
                    Group {
                        if !self.animationFinished {
                            Text("4つの言葉を比較して、\n小さい方から当てはまるものに番号を付けよう!")
                                .padding()
                                .font(.headline)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .background(Color.yellow.opacity(0.3))
                                .cornerRadius(10)
                        }
                        
                        Text("お題")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.horizontal, 10)
                        let theme = self.viewModel.themeData.theme
                        VStack(alignment: .center) {
                            Text(theme.theme)
                                .font(.custom("STBaoliTC-Regular", size: 20))
                            Text(theme.lowNumberTheme)
                                .foregroundColor(.red)
                            Text(theme.highNumberTheme)
                                .foregroundColor(.green)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    ForEach(self.viewModel.rankedAnswer.indices, id: \.self) { index in
                        let rankedAnswer = self.viewModel.rankedAnswer[index]
                        HStack {
                            Spacer()
                            
                            Text(rankedAnswer.answer.answer)
                                .frame(width: self.showCorrectNumber ? geometry.size.width * 0.4 : geometry.size.width * 0.6)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            self.isPressed = true
                                            self.pressedIndex = index
                                        }
                                        .onEnded { _ in
                                            self.isPressed = false
                                        }
                                )
                                .overlay(
                                    Group {
                                        if self.pressedIndex == index && self.isPressed && self.animationFinished {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.yellow)
                                                    .frame(minWidth: geometry.size.width * 0.5, minHeight: geometry.size.height * 0.2)
                                                    .lineLimit(5)
                                                Text(rankedAnswer.answer.reason ?? "理由記載なし")
                                                    .foregroundColor(.black)
                                                    .padding()
                                            }
                                            .padding()
                                            .offset(y: -100)
                                        }
                                    }
                                )
                                .zIndex(self.pressedIndex == index ? 1 : 0)
                            
                            
                            Spacer()
                            
                            Button {
                                self.isShowingPopup = true
                                self.selectedButtonIndex = index
                            } label: {
                                Text(data.answerForButton(index))
                                    .font(.custom("STBaoliTC-Regular", size: 50))
                                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                                    .border(Color.black, width: 3)
                                    .foregroundColor(Color(red: 1.0 - (Double(data.answerForButton(index)) ?? 0) / 4.0, green: (Double(data.answerForButton(index)) ?? 0) / 4.0, blue: 0))
                                    .cornerRadius(6)
                            }
                            .disabled(self.pushDecideButton)
                            .overlay{
                                Image(systemName: data.judgeCorrectness(index) == Correctness.correct ? "circle" : "xmark")
                                    .font(.custom("STBaoliTC-Regular", size: 90))
                                    .foregroundColor(data.judgeCorrectness(index) == Correctness.correct ? .green : .red)
                                    .opacity(self.pushDecideButton ? 1 : 0)
                                    .scaleEffect(self.pushDecideButton ? 1 : 4)
                                    .animation(
                                        Animation.spring(duration: TimeInterval(1))
                                            .delay(Double(index) * 1), value: self.pushDecideButton) // インデックスごとに遅延を設定
                            }
                            
                            if self.pushDecideButton {
                                Text(data.correctNumberForButton(index))
                                    .font(.custom("STBaoliTC-Regular", size: 50))
                                    .foregroundColor(data.judgeCorrectness(index) == Correctness.correct ? .green : .red)
                                    .opacity(self.showCorrectNumber ? 1 : 0) // Apply opacity based on a state variable
                                    .animation(.easeInOut, value: self.showCorrectNumber) // Add animation
                                
                                // Use DispatchQueue to delay the appearance
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                            withAnimation {
                                                self.showCorrectNumber = true
                                                self.animationFinished = true
                                            }
                                        }
                                    }
                            }
                            
                            Spacer()
                        }
                        .onAppear{
                            self.data.setCorrectNumber(index: index, rank: String(rankedAnswer.rank))
                        }
                    }
                    .padding()
                    
                    if self.pushDecideButton {
                        HStack {
                            let totalPoint = data.countCorrectAnswers()
                            Text(String(totalPoint))
                                .font(.custom("STBaoliTC-Regular", size: 50))
                                .foregroundColor(Color(red: 1.0 - (Double(totalPoint) ) / 5.0, green: (Double(totalPoint) ) / 5.0, blue: 0))
                                .opacity(self.showCorrectNumber ? 1 : 0)
                                .scaleEffect(self.showCorrectNumber ? 1 : 6)
                            Text("/4点")
                                .font(.custom("STBaoliTC-Regular", size: 50))
                                .foregroundColor(.green)
                        }
                    }
                    
                    Spacer()
                    if self.pushDecideButton && self.animationFinished {
                        
                        Button {
                            navigationPath.append(.pathFeedBack(self.viewModel.themeData))
                        } label: {
                            Text("次へ")
                                .font(.custom("STBaoliTC-Regular", size: 15))
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                        }
                        .buttonStyle(MyButtonStyle())
                    } else if !self.pushDecideButton {
                        Button {
                            self.pushDecideButton = true
                        } label: {
                            Text("決定")
                                .font(.custom("STBaoliTC-Regular", size: 15))
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                        }
                        .buttonStyle(MyButtonStyle())
                    }
                    
                }
            }
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
            .overlay(
                Group {
                    if isShowingPopup {
                        NumberPopupView(isShowingPopup: self.$isShowingPopup, data: self.$data, selectedButtonIndex: self.$selectedButtonIndex)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.5))
                            .edgesIgnoringSafeArea(.all)
                    }
                })
        }
    }
}

struct GameView_Previews: PreviewProvider {
    @State private var text: String = ""
    @Environment(\.dismiss) var dismiss
    
    static let previewsThemeData = ThemeData(
        id: "1",
        theme: Theme(id: "1", theme: "ゾンビの世界で生き残れる隠れ場所", lowNumberTheme: "生き残れない場所", highNumberTheme: "生き残れる場所"),
        otherThemeAnswers: [Answer(id: "1", answer: "アンブレラ社", number: "9", reason: nil),
                            Answer(id: "1", answer: "空き家", number: "4", reason: nil),
                            Answer(id: "1", answer: "研究室", number: "3", reason: nil)],
        myAnswer: Answer(id: "1", answer: "これは私の回答で[病院]", number: "2", reason: nil))
    static var previews: some View {
        @State var navigationPath: [NavigationPath] = []
        GameView(navigationPath: $navigationPath, viewModel: GameViewModel(themeData: previewsThemeData))
    }
}

struct userAnswerData {
    var answers: answers
    var correctNumbers: correctNumbers
    
    mutating func judgeCorrectness(_ index: Int) -> Correctness {
        let selectedAnswer = answerForButton(index)
        let correctNumber = correctNumberForButton(index)
        if selectedAnswer == correctNumber {
            return .correct
        } else {
            return .incorrect
        }
    }
    
    func countCorrectAnswers() -> Int {
        var correctCount = 0
        
        for i in 1..<5 {
            let selectedAnswer = answerForButton(i)
            let correctNumber = correctNumberForButton(i)
            
            if selectedAnswer == correctNumber {
                correctCount += 1
            }
        }
        
        return correctCount
    }
    
    func answerForButton(_ index: Int) -> String {
        switch index {
        case 0:
            return answers.answer1
        case 1:
            return answers.answer2
        case 2:
            return answers.answer3
        case 3:
            return answers.answer4
        default:
            return ""
        }
    }
    
    func correctNumberForButton(_ index: Int) -> String {
        switch index {
        case 0:
            return correctNumbers.correctNumber1
        case 1:
            return correctNumbers.correctNumber2
        case 2:
            return correctNumbers.correctNumber3
        case 3:
            return correctNumbers.correctNumber4
        default:
            return ""
        }
    }
    
    mutating func setCorrectNumber(index: Int, rank: String) {
        switch index {
        case 0:
            self.correctNumbers.correctNumber1 = rank
        case 1:
            self.correctNumbers.correctNumber2 = rank
        case 2:
            self.correctNumbers.correctNumber3 = rank
        case 3:
            self.correctNumbers.correctNumber4 = rank
        default: break
            // ここには来ない
        }
    }
}

struct answers {
    var answer1: String = ""
    var answer2: String = ""
    var answer3: String = ""
    var answer4: String = ""
}

struct correctNumbers {
    var correctNumber1: String = ""
    var correctNumber2: String = ""
    var correctNumber3: String = ""
    var correctNumber4: String = ""
}

enum Correctness {
    case correct
    case incorrect
}
