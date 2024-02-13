//
//  GameView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/13.
//

import SwiftUI

struct GameView: View {
    @State private var isShowingPopup = false
    @State private var data = answerData(sentences: sentences(), answers: answers())
    @State private var selectedButtonIndex: Int?
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("hkjofgkofgjifdjgiodfnjdfnfdojdfiojdfijdfoibjdfoibdnfbodfnbi")
                    .padding()
                
                ForEach(0..<4) { index in
                    HStack {
                        Spacer()
                        
                        Text("No,\(index)gjdgifdjgdijgdifjgdfigjdfigjdfigbdfd")
                        
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
                        Spacer()
                    }
                }
                .padding()
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("決定")
                        .font(.custom("STBaoliTC-Regular", size: 15))
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                }
                .buttonStyle(MyButtonStyle())
                
            }
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

struct answerData {
    var theme: String = ""
    var sentences: sentences
    var answers: answers
    
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
