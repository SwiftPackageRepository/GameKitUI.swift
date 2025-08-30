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
/// Created by Sascha Müllner on 24.11.20.

import SwiftUI
import GameKit
import GameKitUI

@main
struct GKMatchMakerApp: App {
    @State private var routes: [Route] = []
    @State private var showAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAuthentication = false
    @State private var showInvite = false
    @State private var showMatch = false
    @State private var invite: Invite = Invite.zero
    @State private var gkMatch: GKMatch?

    private let appModel = GKMatchMakerAppModel()

    public var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routes) {
                MenuView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("BackgroundColor").ignoresSafeArea())
                    .onAppear { // Call subscribe here
                        appModel.subscribe()
                    }
                    .navigationDestination(for: Route.self) { route in
                        switch(route) {
                            case .authentication:
                                GKAuthenticationView { (error) in
                                    Task {
                                        await MainActor.run {
                                            self.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                                        }
                                    }
                                } authenticated: { (player) in
                                    Task {
                                        await MainActor.run {
                                            self.showAuthentication = false
                                        }
                                    }
                                }
                            case .gameCenter:
                                GKInviteView(
                                    invite: self.invite.gkInvite?.invite
                                ) {
                                } failed: { (error) in
                                    Task {
                                        await MainActor.run {
                                            self.showAlert(title: "Invitation Failed", message: error.localizedDescription)
                                        }
                                    }
                                } started: { (gkMatch) in
                                    Task {
                                        await MainActor.run {
                                            self.showInvite = false
                                            self.gkMatch = gkMatch
                                        }
                                    }
                                }
                            case .matchMaking:
                                MatchMakingView()
                        }
                    }
                }
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text(self.alertTitle),
                      message: Text(self.alertMessage),
                      dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}
