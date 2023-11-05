//
//  ViewModel.swift
//  RealityKitDynamicTextures
//
//  Created by Sebastian Buys on 11/5/23.
//

import Foundation
import Combine
import SwiftUI
import RealityKit

struct Message {
    var text: String = "Hello World"
    var backgroundColor: Color = .black
    var foregroundColor: Color = .white
    var fontSize: CGFloat = 200
    var size: CGSize = CGSize(width: CGFloat(2048), height: CGFloat(1024))
}

class ViewModel: ObservableObject {
    enum Mode {
        case editing
        case viewing
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var message: Message = Message()
    @Published var mode: Mode = .viewing
    
    @Published var texture: TextureResource?
    
    // Single pass through subject ("signal") for resetting the view.
    var resetSignal: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
}


