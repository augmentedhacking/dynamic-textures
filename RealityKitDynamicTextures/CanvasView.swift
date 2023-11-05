//
//  CanvasView.swift
//  RealityKitDynamicTextures
//
//  Created by Sebastian Buys on 11/5/23.
//

import SwiftUI

struct CanvasView: View {
    @Binding var message: Message
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(message.backgroundColor)

            VStack {
                Text(message.text)
                    .font(.system(size: floor(message.fontSize)))
                    .foregroundStyle(message.foregroundColor)
                
            }
        }
        .frame(width: message.size.width, height: message.size.height)
    }
}

#Preview {
    CanvasView(message: .constant(Message(text: "Hello World!")))
}
