///
/// GKMatchMakerViewModel.swift
/// GKMatchMaker
///
/// Created by Sascha Müllner on 24.11.20.


import Foundation
import SwiftUI
import GameKit

class MatchMakingViewModel: ObservableObject {
    
    @Published public var showModal = false
    @Published public var showAlert = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    @Published public var currentState: String = "Loading GameKit..."

    public init() {
    }
    
    public func load() {
        self.showMatchMakerModal()
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }

    public func showMatchMakerModal() {
        self.showModal = true
    }
}
