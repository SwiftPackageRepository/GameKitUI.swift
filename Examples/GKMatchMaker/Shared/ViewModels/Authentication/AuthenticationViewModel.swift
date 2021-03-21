///
/// AuthenticationViewModel.swift
/// GKMatchMaker
///
/// Created by smuellner on 23.02.21.


import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {

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
    }
}