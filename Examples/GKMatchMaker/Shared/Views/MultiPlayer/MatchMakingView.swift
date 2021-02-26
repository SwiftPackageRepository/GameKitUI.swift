///
/// GKMatchMakerView.swift
/// GKMatchMaker
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
                if self.viewModel.showMatch {
                    ForEach(self.viewModel.match!.players, id: \.self) { player in
                        Text(player.displayName)
                            .font(.title)
                            .padding(8)
                    }
                } else {
                    Text(self.viewModel.currentState)
                        .font(.body)
                        .padding(8)
                    Button() {
                        self.viewModel.showMatchMakerModal()
                    } label: {
                        Text("Create Match")
                            .primaryButtonStyle()
                    }
                }
            }
            .navigationBarTitle(Text("GameKit Matchmaker"))
        }
        .onAppear() {
            self.viewModel.load()
        }
        .sheet(isPresented: self.$viewModel.showModal) {
            GKMatchmakerView(
                minPlayers: 2,
                maxPlayers: 4,
                inviteMessage: "Let us play together!"
            ) {
                self.viewModel.showModal = false
                self.viewModel.currentState = "Player Canceled"
            } failed: { (error) in
                self.viewModel.showModal = false
                self.viewModel.currentState = "Match Making Failed"
                self.viewModel.showAlert(title: "Match Making Failed", message: error.localizedDescription)
            } started: { (match) in
                self.viewModel.showModal = false
                self.viewModel.match = match
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
