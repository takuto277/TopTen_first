//
//  SelectThemeView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/12.
//

import SwiftUI

struct SelectThemeView: View {
    @State private var isShowingPopup = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Text("遊びたいお題を選ぼう！")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(10)
                    
                    Spacer()
                    Button {
                        self.isShowingPopup = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                            .clipShape(Circle())
                    }
                    
                }
                .padding()
                List {
                    ForEach(0..<30) { index in
                        NavigationLink {
                            AsignNumberAnswerView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("aaaaaaaaaaaaaaaaaaaasasasasasaaasfsfasdasdasdaafddfbafdbdfvdfvdfbdfb")
                            
                        }
                    }
                }
                Button {
                    dismiss()
                } label: {
                    Text("戻る")
                        .font(.custom("STBaoliTC-Regular", size: 15))
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.02)
                }
                .buttonStyle(BackButtonStyle())
            }
            .overlay(
                Group {
                    if isShowingPopup {
                        PopupView(isShowingPopup: self.$isShowingPopup, topic: .selectTheme)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.5))
                            .edgesIgnoringSafeArea(.all)
                    }
                })
        }
    }
}

#Preview {
    SelectThemeView()
}
