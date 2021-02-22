///
/// GKMatchMakerViewModel.swift
/// GKMatchMaker
///
/// Created by Sascha Müllner on 24.11.20.


import Foundation
import Combine

class MatchMakingViewModel: ObservableObject {

    @Published public var activeSheet :MatchMakingViewSheet = .authentication
    @Published public var showModal = false
    @Published public var showAlert = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    @Published public var currentState: String = "Loading GameKit..."

    public init() {
    }
    
    public func load() {
        self.showAuthenticationModal()
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }

    public func showAuthenticationModal() {
        self.showModal = true
        self.activeSheet = .authentication
    }

    public func showMatchMakerModal() {
        self.showModal = true
        self.activeSheet = .matchmaker
    }
}

public enum MatchMakingViewSheet {
    case authentication
    case matchmaker
}
