//
//  PopupView.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/13.
//

import SwiftUI

struct PopupView: View {
    @Binding var isShowingPopup: Bool
    var topic: HelpTopic
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Text("ヘルプ")
                    
                    Spacer()
                    
                    Button {
                        self.isShowingPopup = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.blue)
                            .clipShape(Circle())
                    }
                    
                }
                .padding()
                
                
                Text(topic.rawValue)
                    .padding()
                
                Spacer()
            }
            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

#Preview {
    PopupView(isShowingPopup: Binding.constant(true), topic: .selectTheme)
}
