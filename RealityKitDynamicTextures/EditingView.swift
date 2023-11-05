//
//  EditingView.swift
//  RealityKitDynamicTextures
//
//  Created by Sebastian Buys on 11/5/23.
//

import SwiftUI

struct EditingView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20.0) {
                TextField("Enter text", text: $viewModel.message.text)
                    .foregroundColor(.white)
                    .padding()
                
                Divider()
                
                HStack {
                    Slider(value: $viewModel.message.fontSize, in: 10...500)
                    
                    Text("\(String(format: "%.0f", floor(viewModel.message.fontSize)))")
                }
                
                ColorPicker("Background", selection: $viewModel.message.backgroundColor)
                ColorPicker("Foreground", selection: $viewModel.message.foregroundColor)
                
                
                GeometryReader { geometry in
                    CanvasView(message: $viewModel.message)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .scaleEffect(geometry.size.width / viewModel.message.size.width)
                }
                
                Divider()
                
                
            }
        } 
        .padding()
    }
}

#Preview {
    EditingView(viewModel: ViewModel())
}
