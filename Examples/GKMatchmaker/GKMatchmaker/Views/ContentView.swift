///
/// ContentView.swift
/// GKMatchmaker
/// 
/// Created by Sascha Müllner on 24.11.20.


import SwiftUI
import GameKitUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack() {
                Text(self.viewModel.currentState)
                    .font(.title)
            }
            .navigationBarTitle(Text("GameKit Matchmaker"), displayMode: .inline)
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
                        self.viewModel.showMatchMaker()
                    }
                } else if self.viewModel.activeSheet == .matchmaker {
                    GKMatchMakerView(
                        minPlayers: 2,
                        maxPlayers: 4,
                        inviteMessage: "Letus play together!"
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
