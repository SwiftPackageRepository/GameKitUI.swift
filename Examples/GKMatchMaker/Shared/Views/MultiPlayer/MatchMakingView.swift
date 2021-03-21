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
                Button() {
                    self.viewModel.showMatchMakerModal()
                } label: {
                    Text("Create Match")
                        .primaryButtonStyle()
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
