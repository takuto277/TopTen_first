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
    @Environment(\.presentationMode) var presentationMode
    
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
                    Group {
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
                    
                    Group {
                        Text("回答内容")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.horizontal, 10)
                        HStack {
                            Text("彼氏が高校生の頃から貯金して貯めたお金で買った財布")
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                            Text(String(randomNumber))
                                .font(.custom("STBaoliTC-Regular", size: 50))
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                                .background(Color(red: 1.0 - Double(randomNumber) / 10.0, green: Double(randomNumber) / 10.0, blue: 0))
                                .cornerRadius(6)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    Group {
                        TextEditor(text: $text)
                            .padding()
                            .frame(height: 150)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
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
        }
    }
}

#Preview {
    FeedbackView()
}