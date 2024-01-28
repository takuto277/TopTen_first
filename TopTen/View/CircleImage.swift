//
//  CircleImage.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/01/28.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
            .frame(width: 10, height: 10)
    }
}

#Preview {
    CircleImage(image: Image("turtlerock"))
}
