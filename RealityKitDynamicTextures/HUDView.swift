//
//  HUDView.swift
//  RealityKitDynamicTextures
//
//  Created by Sebastian Buys on 11/5/23.
//

import SwiftUI

struct HUDView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: reset) {
                    Image(systemName: "arrow.clockwise").padding()
                }
                .foregroundColor(.white)
                .background(.regularMaterial, in: .circle)
                
                Spacer()
                
                Button(action: showEditingView) {
                    Image(systemName: "square.and.pencil").padding()
                }
                .foregroundColor(.white)
                .background(.regularMaterial, in: .circle)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func reset() {
        viewModel.resetSignal.send()
    }
    
    func showEditingView() {
        viewModel.mode = .editing
    }
    
    
}

#Preview {
    HUDView(viewModel: ViewModel())
}
