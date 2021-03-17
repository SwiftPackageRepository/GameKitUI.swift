///
/// GKMatchMakerApp.swift
/// GKMatchMaker
///
/// Created by Sascha Müllner on 24.11.20.

import SwiftUI
import GameKit
import GameKitUI

@main
struct GKMatchMakerApp: App {
    @ObservedObject var viewModel = GKMatchMakerAppModel()

    public var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .alert(isPresented: self.$viewModel.showAlert) {
                        Alert(title: Text(self.viewModel.alertTitle),
                              message: Text(self.viewModel.alertMessage),
                              dismissButton: .default(Text("Ok")))
                    }
                if self.viewModel.showAuthentication {
                    GKAuthenticationView { (error) in
                        self.viewModel.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                    } authenticated: { (player) in
                        self.viewModel.showAuthentication = false
                    }
                } else if self.viewModel.showInvite {
                    GKInviteView(
                        invite: self.viewModel.invite.gkInvite!
                    ) {
                    } failed: { (error) in
                        self.viewModel.showAlert(title: "Invitation Failed", message: error.localizedDescription)
                    } started: { (match) in
                        self.viewModel.showInvite = false
                        self.viewModel.match = match
                    }
                } else if self.viewModel.showMatch,
                   let match = self.viewModel.match {
                    MatchView(match)
                }
            }
        }
    }
}
