///
/// MatchMakingView.swift
/// MatchMaking
///
/// Created by Sascha Müllner on 24.11.20.

import SwiftUI
import GameKitUI


struct MatchMakingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = MatchMakingViewModel()

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack() {
                Text(self.viewModel.currentState)
                    .font(.body)
                    .padding(8)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle(Text("GameKit Matchmaker"))
        .onAppear() {
            self.viewModel.load()
        }
        .sheet(isPresented: self.$viewModel.showModal) {
            if self.viewModel.activeSheet == .authentication {
                GKAuthenticationView { (state) in
                    switch state {
                        case .started:
                            self.viewModel.currentState = "Authentication Started"
                            break
                        case .failed:
                            self.viewModel.currentState = "Failed"
                            break
                        case .deauthenticated:
                            self.viewModel.currentState = "Deauthenticated"
                            break
                        case .succeeded:
                            break
                    }
                } failed: { (error) in
                    self.viewModel.showModal = false
                    self.viewModel.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                } authenticated: { (playerName) in
                    self.viewModel.currentState = playerName
                    self.viewModel.showMatchMakerModal()
                }
            } else if self.viewModel.activeSheet == .matchmaker {
                GKMatchMakerView(
                    minPlayers: 2,
                    maxPlayers: 4,
                    inviteMessage: "Let us play together!"
                ) {
                    self.viewModel.showModal = false
                    self.viewModel.currentState = "Player Canceled"
                } failed: { (error) in
                    self.viewModel.showModal = false
                    self.viewModel.showAlert(title: "Match Making Failed", message: error.localizedDescription)
                } started: { (match) in
                    self.viewModel.showModal = false
                    self.viewModel.currentState = "Match Started"
                }
            }
        }
        .alert(isPresented: self.$viewModel.showAlert) {
            Alert(title: Text(self.viewModel.alertTitle),
                  message: Text(self.viewModel.alertMessage),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct MatchMakingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchMakingView()
    }
}
