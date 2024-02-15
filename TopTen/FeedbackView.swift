//
//  FeedbackView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/16.
//

import SwiftUI

struct FeedbackView: View {
    let randomNumber = Int.random(in: 1...10)
    @State private var text: String = ""
    @State private var isEditing = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Text("ゲームを遊んでくれてありがとう！\n今回の回答理由があれば教えてね")
                        .padding()
                        .border(.black)
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("お題")
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05)
                                .border(.black, width: 1)
                            Text("恋人にクリスマスプレゼントをもらう。もらっても嬉しくない。もらったら嬉しい。")
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.1)
                                .border(.black, width: 1)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("回答内容")
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05)
                                .border(.black, width: 1)
                            
                            HStack {
                                Text("彼氏が高校生の頃から貯金して貯めたお金で買った財布")
                                    .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.1)
                                    .border(.black, width: 1)
                                Text(String(randomNumber))
                                    .font(.custom("STBaoliTC-Regular", size: 50))
                                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                                    .border(Color.black, width: 3)
                                    .background(Color(red: 1.0 - Double(randomNumber) / 10.0, green: Double(randomNumber) / 10.0, blue: 0))
                                    .cornerRadius(6)
                            }
                        }
                    }
                    .padding()
                    
                    VStack {
                        
                        TextEditor(text: $text)
                            .padding()
                            .frame(height: 150) // 高さを設定
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8.0)
                            .border(Color.gray, width: 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .overlay(
                                Text("今回の回答理由があれば記入をお願いします。\n他プレイヤーの出題回答に使用させていただきます。")
                                    .font(.custom("STBaoliTC-Regular", size: 15))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .opacity(text.isEmpty ? 1 : 0) // テキストが空でない場合は非表示にする
                            )
                        HStack {

                            
                            NavigationLink {
                                GameView()
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                Text("次へ")
                                    .font(.custom("STBaoliTC-Regular", size: 15))
                                    .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                            }
                            .buttonStyle(MyButtonStyle())
                        }
                        .padding()
                        
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    FeedbackView()
}
