///
/// MIT License
///
/// Copyright (c) 2020 Sascha Müllner
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Created by smuellner on 22.02.21.
///

import SwiftUI
import GameKitUI
import GameKit // Added GameKit import for GKPlayer

struct AuthenticationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showModal = false
    @State private var showAlert = false
    @State private var isAuthenticated = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var currentState: String = "Loading GameKit..."
    @State private var player: GKPlayer?
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack() {
                Text(self.currentState)
                    .font(.body)
                    .padding(8)
                if self.isAuthenticated,
                   let player = self.player {
                    PlayerView(player)
                } else {
                    Button() {
                        self.showModal = true
                    } label: {
                        Text("Login")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .navigationTitle(Text("GameKit Authentication"))
        }
        .onAppear() {
            // Trigger authentication when the view appears
            Task {
                do {
                    let authenticatedPlayer = try await GKAuthentication.shared.authenticate()
                    self.player = authenticatedPlayer
                    self.isAuthenticated = true
                    self.currentState = "Authenticated"
                } catch let error as AuthenticationError {
                    switch error {
                    case .uiRequired(let viewController):
                        // Present the system authentication UI
                        // This will be handled by the UnifiedAuthenticationView
                        // We just need to make sure the sheet is presented
                        self.showModal = true
                    case .gameKitError(let gkError):
                        self.showAlert(title: "Authentication Failed", message: gkError.localizedDescription)
                        self.currentState = gkError.localizedDescription
                    }
                } catch {
                    self.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                    self.currentState = error.localizedDescription
                }
            }
        }
        .sheet(isPresented: self.$showModal) {
           GKAuthenticationView { (error) in
                Task { @MainActor in
                    self.showModal = false
                    self.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                    self.currentState = error.localizedDescription
                }
            } authenticated: { (player) in
                Task { @MainActor in
                    self.showModal = false
                    self.player = player
                    self.isAuthenticated = true
                    self.currentState = "Authenticated"
                }
            }
            .frame(width: 640, height: 480) // Keep the frame for modal presentation
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text(self.alertTitle),
                  message: Text(self.alertMessage),
                  dismissButton: .default(Text("Ok")))
        }
    }
    
    private func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
