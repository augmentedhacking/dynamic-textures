//
//  ContentView.swift
//  RealityKitDynamicTextures
//
//  Created by Sebastian Buys on 11/5/23.
//

import Combine
import SwiftUI
import RealityKit

struct ContentView : View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            HUDView(viewModel: viewModel)
                
        }
        .sheet(isPresented: .constant(viewModel.mode == .editing),
               onDismiss: dismissSheet) {
            EditingView(viewModel: viewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
        }
    }
    
    func dismissSheet() {
        viewModel.mode = .viewing
    }
}

struct ARViewContainer: UIViewRepresentable {
    var viewModel: ViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(viewModel: viewModel, frame: .zero)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

#Preview {
    ContentView()
}
