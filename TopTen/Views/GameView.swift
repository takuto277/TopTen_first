//
//  GameView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/13.
//

import SwiftUI

struct GameView: View {
    @State private var isShowingPopup = false
    @State private var data = userAnswerData(sentences: sentences(), answers: answers(), correctNumbers: correctNumbers())
    @State private var selectedButtonIndex: Int?
    @State private var pushDecideButton = false
    @State private var showCorrectNumber = false
    @State private var animationFinished = false
    
    var body: some View {
        GeometryReader { geometry in
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
                    Text("恋人にクリスマスプレゼントをもらう。もらっても嬉しくない。もらったら嬉しい。")
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                
                ForEach(1..<5) { index in
                    HStack {
                        Spacer()
                        
                        Text("No,\(index)gjdgifdjgdijgdifjgdfigjdfigjdfigbdfd")
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        
                        Spacer()
                        
                        Button {
                            self.isShowingPopup = true
                            self.selectedButtonIndex = index
                        } label: {
                            Text(data.answerForButton(index))
                                .font(.custom("STBaoliTC-Regular", size: 50))
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                                .border(Color.black, width: 3)
                                .foregroundColor(Color(red: 1.0 - (Double(data.answerForButton(index)) ?? 0) / 5.0, green: (Double(data.answerForButton(index)) ?? 0) / 5.0, blue: 0))
                                .cornerRadius(6)
                        }
                        .disabled(self.pushDecideButton)
                        .overlay{
                            Image(systemName: data.judgeCorrectness(index) == Correctness.correct ? "circle" : "xmark")
                                .font(.custom("STBaoliTC-Regular", size: 90))
                                .foregroundColor(data.judgeCorrectness(index) == Correctness.correct ? .green : .red)
                                .opacity(self.pushDecideButton ? 1 : 0)
                                .offset(y: self.pushDecideButton ?  0 :  -20)
                                .offset(x: self.pushDecideButton ? 0 : -25 )
                                .animation(
                                    Animation.spring(duration: TimeInterval(1))
                                        .delay(Double(index - 1) * 1), value: self.pushDecideButton) // インデックスごとに遅延を設定
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
                    
                    NavigationLink {
                        FeedbackView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("次へ→")
                            .font(.custom("STBaoliTC-Regular", size: 15))
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                    }
                    .buttonStyle(NextButtonStyle())
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

#Preview {
    GameView()
}

struct userAnswerData {
    var theme: String = ""
    var sentences: sentences
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
        case 1:
            return answers.answer1
        case 2:
            return answers.answer2
        case 3:
            return answers.answer3
        case 4:
            return answers.answer4
        default:
            return ""
        }
    }
    
    func correctNumberForButton(_ index: Int) -> String {
        switch index {
        case 1:
            return correctNumbers.correctNumber1
        case 2:
            return correctNumbers.correctNumber2
        case 3:
            return correctNumbers.correctNumber3
        case 4:
            return correctNumbers.correctNumber4
        default:
            return ""
        }
    }
}

struct sentences {
    var sentence1: String = ""
    var sentence2: String = ""
    var sentence3: String = ""
    var sentence4: String = ""
}

struct answers {
    var answer1: String = ""
    var answer2: String = ""
    var answer3: String = ""
    var answer4: String = ""
}

struct correctNumbers {
    var correctNumber1: String = "1"
    var correctNumber2: String = "2"
    var correctNumber3: String = "3"
    var correctNumber4: String = "4"
}

enum Correctness {
    case correct
    case incorrect
}
