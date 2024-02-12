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
        VStack {
            HStack {
                Spacer()
                Text("お題を選んでください")
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
                    Text("Row \(index)")
                }
            }
            VStack {
                Button("戻る") {
                    dismiss()
                }
                
            }
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

#Preview {
    SelectThemeView()
}
