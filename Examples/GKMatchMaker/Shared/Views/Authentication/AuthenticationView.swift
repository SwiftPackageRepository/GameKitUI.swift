///
/// GKMatchMakerView.swift
/// GKMatchMaker
///
/// Created by smuellner on 22.02.21.
///

import SwiftUI
import GameKitUI

struct AuthenticationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = AuthenticationViewModel()

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack() {
                Text(self.viewModel.currentState)
                    .font(.body)
                    .padding(8)
                Button() {
                    self.viewModel.showAuthenticationModal()
                } label: {
                    Text("Login")
                        .primaryButtonStyle()
                }
            }
            .navigationBarTitle(Text("GameKit Authentication"))
        }
        .onAppear() {
            self.viewModel.load()
        }
        .sheet(isPresented: self.$viewModel.showModal) {
            GKAuthenticationView { (error) in
                self.viewModel.showModal = false
                self.viewModel.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                self.viewModel.currentState = error.localizedDescription
            } authenticated: { (player) in
                self.viewModel.showModal = false
                self.viewModel.currentState = "Hello \(player.displayName)"
            }
        }
        .alert(isPresented: self.$viewModel.showAlert) {
            Alert(title: Text(self.viewModel.alertTitle),
                  message: Text(self.viewModel.alertMessage),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
