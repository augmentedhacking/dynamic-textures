//
//  CustomARView.swift
//  RealityKitDynamicTextures
//
//  Created by Sebastian Buys on 11/5/23.
//

import Foundation
import Combine
import ARKit
import RealityKit
import UIKit
import SwiftUI

class CustomARView: ARView {
    private var subscriptions = Set<AnyCancellable>()
    let viewModel: ViewModel
    
    var planeAnchor: AnchorEntity?
    var messageEntity: ModelEntity?
    
    init(viewModel: ViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIApplication.shared.isIdleTimerDisabled = true
        self.setupARSession()
        self.setupSubscriptions()
        self.setupScene()
    }
    
    private func setupARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical]
        
        session.run(configuration)
    }
    
    private func setupScene() {
        let planeAnchor = AnchorEntity(plane: .vertical)
        scene.addAnchor(planeAnchor)
        
        let planeMesh = MeshResource.generatePlane(width: 1.0, depth: 0.5)
        let messageEntity = ModelEntity(mesh: planeMesh)
        
        planeAnchor.addChild(messageEntity)
        self.messageEntity = messageEntity
        
        self.updateMessageTexture(message: viewModel.message)
    }
    
    private func reset() {
        // Remove nodes
        messageEntity?.removeFromParent()
        messageEntity = nil
        
        planeAnchor?.removeFromParent()
        planeAnchor = nil
        
        setupScene()
    }
    
    private func setupSubscriptions() {
        // Subscribe to message changes and regenerate texture
        // Drop first message so this doesn't run when app first loads
        self.viewModel.$message.dropFirst().sink { message in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.updateMessageTexture(message: message)
            }
        }.store(in: &subscriptions)
        
        // Subscribe to reset signal
        self.viewModel.resetSignal.sink { [weak self] in
            guard let self = self else { return }
            self.reset()
        }.store(in: &subscriptions)
    }
    
    private func updateMessageTexture(message: Message) {
        guard let textureResource = self.makeTexture(message: message) else {
            print("Error making texture from message", message)
            return
        }
        
        let texture = MaterialParameters.Texture(textureResource)
        
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .white, texture: texture)
        material.textureCoordinateTransform.scale = SIMD2<Float>(x: 1, y: 1)
        
        self.messageEntity?.model?.materials = [material]
    }
    
    private func makeTexture(message: Message) -> TextureResource? {
        let renderer = ImageRenderer(content: CanvasView(message: .constant(message)))
        
        return renderer.cgImage.flatMap { cgImage in
            return try? TextureResource.generate(from: cgImage, options: .init(semantic: .color))
        }
    }
}
