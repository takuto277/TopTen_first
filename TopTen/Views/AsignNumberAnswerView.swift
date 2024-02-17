//
//  AsignNumberAnswerView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/13.
//

import SwiftUI

struct AsignNumberAnswerView: View {
    let randomNumber = Int.random(in: 1...10)
    @State private var text: String = ""
    @State private var isEditing = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 20){
                        Text("お題と番号に沿った文章を作成してみよう！")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                HStack {
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
                    }
                    
                    Spacer()
                    
                    Text(String(randomNumber))
                        .font(.custom("STBaoliTC-Regular", size: 100))
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                        .border(Color.black, width: 3)
                        .background(Color(red: 1.0 - Double(randomNumber) / 10.0, green: Double(randomNumber) / 10.0, blue: 0))
                        .cornerRadius(6)
                }
                .padding()
                
                HStack {
                    Image(systemName: "1.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(.red)
                        .clipShape(Circle())
                    
                    LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 0/255, blue: 0/255), Color(red: 1/255, green: 255/255, blue: 0/255)]), startPoint: .leading, endPoint: .trailing)
                        .frame(height: 5)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Image(systemName: "10.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(.green)
                        .clipShape(Circle())
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
                            Text("例: \n[お題]「学校の七不思議にありそうなこと」 \n[順番]10番 \n[入力]トイレの花子さん")
                                .font(.custom("STBaoliTC-Regular", size: 15))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .opacity(text.isEmpty ? 1 : 0) // テキストが空でない場合は非表示にする
                        )
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("戻る")
                                .font(.custom("STBaoliTC-Regular", size: 15))
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                        }
                        .buttonStyle(BackButtonStyle())
                        
                        NavigationLink {
                            GameView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("決定")
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
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    AsignNumberAnswerView()
}