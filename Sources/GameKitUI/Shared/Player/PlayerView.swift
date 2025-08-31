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
/// Created by Sascha Müllner on 03.04.21.

import SwiftUI
import GameKit

public struct PlayerView: View {
    @StateObject var viewModel: PlayerViewModel
    @State var showDeveloperInformation = false
    
    public init(_ player: GKPlayer) {
        _viewModel = StateObject(wrappedValue: PlayerViewModel(player))
    }

    public var body: some View {
        ZStack {
            playerIcon
            if showDeveloperInformation {
                developerInformation
            }
        }
        .onTapGesture { tapGesture in
            showDeveloperInformation.toggle()
        }
        .onAppear() {
            self.viewModel.load()
        }
    }

    var playerIcon: some View {
        VStack(alignment: .center, spacing: 16) {
            if self.viewModel.imageLoaded,
               let sendableImage = self.viewModel.image {
#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
                Image(uiImage: sendableImage.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())
                    .shadow(radius: 10)
#else
                Image(nsImage: sendableImage.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())
                    .shadow(radius: 10)
#endif
            } else {
                Image(systemName: "person.fill")
                    .font(Font.custom("System", size: 64))
                    .frame(width: 128, height: 128)
                    .background(Color("TextColor"))
                    .foregroundColor(Color("BackgroundColor"))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            Text(self.viewModel.player.displayName)
        }
    }

    var developerInformation: some View {
#if DEBUG
        VStack(alignment: .center, spacing: 4) {
            Text("Alias: \(self.viewModel.player.alias)")
                .font(.footnote)
            Text(self.viewModel.player.gamePlayerID)
                .font(.footnote)
            Text(self.viewModel.player.teamPlayerID)
                .font(.footnote)
        }
        .padding()
        .background(.background)
        .cornerRadius(8)
#endif
    }
}
