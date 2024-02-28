//
//  AsignNumberAnswerView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/13.
//

import SwiftUI

struct AsignNumberAnswerView<ViewModel: AsignNumberAnswerViewModel>: View {
    @Binding var navigationPath: [NavigationPath]
    @ObservedObject var viewModel: ViewModel
    @State private var text: String = ""
    @State private var showingErrorAlert = false
    @State private var showingConfirmAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
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
                            let data = viewModel.themeData.theme
                            Group {
                                Text("お題")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .padding(.horizontal, 10)
                                VStack(alignment: .leading) {
                                    Text(data.theme)
                                        .font(.custom("STBaoliTC-Regular", size: 20))
                                    Text(data.lowNumberTheme)
                                        .foregroundColor(.red)
                                    Text(data.highNumberTheme)
                                        .foregroundColor(.green)
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                        
                        Spacer()
                        
                        Text(String(viewModel.randomNumber))
                            .font(.custom("STBaoliTC-Regular", size: 100))
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                            .border(Color.black, width: 3)
                            .background(Color(red: 1.0 - Double(viewModel.randomNumber) / 10.0, green: Double(viewModel.randomNumber) / 10.0, blue: 0))
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
                        ZStack(alignment: .topLeading) {
                            textEditor
                            if text.isEmpty {
                                placeholderText
                            }
                        }
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("戻る")
                                    .font(.custom("STBaoliTC-Regular", size: 15))
                                    .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                            }
                            .buttonStyle(BackButtonStyle())
                            
                            Button {
                                if self.text.isEmpty {
                                    self.showingErrorAlert = true
                                } else {
                                    self.showingConfirmAlert = true
                                }
                                
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
            }
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
            .onTapGesture {
                self.endEditing(true)
            }
            .alert("注意", isPresented: $showingErrorAlert) {
                
            } message: {
                Text("文章が空です。\n入力してください。")
            }
            .alert("確認", isPresented: $showingConfirmAlert) {
                Button("キャンセル") {
                    self.showingConfirmAlert = false
                }
                Button("OK") {
                    self.viewModel.setMyAnswer(answer: self.text)
                    navigationPath.append(.pathGame(self.viewModel.themeData))
                }
            } message: {
                Text("入力された文章でよろしいですか？")
            }
        }
    }
    
    var placeholderText: some View {
        Text("例: \n[お題]「学校の七不思議にありそうなこと」 \n[順番]10番 \n[入力]トイレの花子さん")
            .foregroundColor(Color(uiColor: .placeholderText))
            .padding(.vertical, 8)
            .allowsHitTesting(false)
    }
    
    var textEditor: some View {
        TextEditor(text: $text)
            .cornerRadius(10.0)
            .padding(.horizontal, -4)
            .frame(minHeight: 150)
    }
}

struct AsignNumberAnswerView_Previews: PreviewProvider {
    @State private var text: String = ""
    @Environment(\.dismiss) var dismiss
    
    static let previewsThemeData = ThemeData(
        id: "1",
        theme: Theme(id: "1", theme: "ゾンビの世界で生き残れる隠れ場所", lowNumberTheme: "生き残れない場所", highNumberTheme: "生き残れる場所"),
        otherThemeAnswers: [Answer(id: "1", answer: "アンブレラ社", number: "9", reason: nil)],
        myAnswer: nil)
    static var previews: some View {
        @State var navigationPath: [NavigationPath] = []
        AsignNumberAnswerView(navigationPath: $navigationPath, viewModel: AsignNumberAnswerViewModel(themeData: previewsThemeData))
    }
}
