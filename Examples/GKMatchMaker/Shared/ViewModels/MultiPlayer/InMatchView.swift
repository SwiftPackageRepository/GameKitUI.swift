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
/// Created by Sascha Müllner on 17.03.21.

import Combine
import SwiftUI
import GameKit
import GameKitService
import GameKitUI

struct InMatchView: View {
    var match: GKMatch

    private var cancellable: AnyCancellable?

    public init(_ match: GKMatch) {
        self.match = match

        GameKitService
            .shared
            .start(match)
        self.cancellable = GameKitService
            .shared
            .received.sink { (match: GKMatch, data: Data, player: GKPlayer) in
                print("Data: \(data)")
            }
    }

    public func send() {
        do {
            let cafe = "Café".data(using: .utf8)!
            try GameKitService
                .shared
                .send(cafe)
        } catch  {
            //
        }
    }

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 8) {
                ForEach(self.match.players, id: \.self) { player in
                    HStack(alignment: .center, spacing: 8) {
                        Button {
                            self.send()
                        } label: {
                            Rectangle()
                                .frame(width: 42, height: 42)
                                .background(Color.red)
                        }

                        Text(player.displayName)
                            .font(.title)
                            .padding(8)
                    }
                }
            }
        }
        .navigationTitle(Text("GameKit Match"))
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    GKMatchManager.shared.cancel()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark.circle").imageScale(.large)
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct InMatchView_Previews: PreviewProvider {
    static var previews: some View {
        InMatchView(GKMatch())
    }
}
