//
//  NumberPopupView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/13.
//

import SwiftUI

struct NumberPopupView: View {
    @Binding var isShowingPopup: Bool
    @Binding var data: answerData
    @Binding  var selectedButtonIndex: Int?
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    ForEach(0..<4) { index in
                        Button {
                            self.isShowingPopup = false
                            
                            switch self.selectedButtonIndex {
                            case 0:
                                self.data.answers.answer1 = "\(index)"
                            case 1:
                                self.data.answers.answer2 = "\(index)"
                            case 2:
                                self.data.answers.answer3 = "\(index)"
                            case 3:
                                self.data.answers.answer4 = "\(index)"
                            default:
                                break
                            }
                        } label: {
                            Text(index.description)
                                .font(.custom("STBaoliTC-Regular", size: 20))
                                .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.05)
                               .border(Color.black, width: 1)
                                .foregroundColor(.blue)
                                .background(.yellow)
                            
                        }
                    }
                    .padding()
                }
                
                Button {
                    self.isShowingPopup = false
                } label: {
                    Text("戻る")
                        .font(.custom("STBaoliTC-Regular", size: 15))
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.01)
                }
                .buttonStyle(BackButtonStyle())
            }
            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let data = answerData(
            theme: "Example Theme",
            sentences: sentences(
                sentence1: "Sentence 1",
                sentence2: "Sentence 2",
                sentence3: "Sentence 3",
                sentence4: "Sentence 4"
            ),
            answers: answers(
                answer1: "Answer 1",
                answer2: "Answer 2",
                answer3: "Answer 3",
                answer4: "Answer 4"
            )
        )

        return NumberPopupView(isShowingPopup: .constant(true), data: .constant(data), selectedButtonIndex: .constant(1))
    }
}
