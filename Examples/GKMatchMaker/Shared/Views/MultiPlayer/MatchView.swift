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

import SwiftUI
import GameKit
import GameKitUI

struct MatchView: View {
    var match: GKMatch

    public init(_ match: GKMatch) {
        self.match = match
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(self.match.players, id: \.self) { player in
                        HStack(alignment: .center, spacing: 8) {
                            Rectangle()
                                .background(Color.red)
                                .frame(width: 42, height: 42)
                            Text(player.displayName)
                                .font(.title)
                                .padding(8)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("GameKit Match"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    GKMatchManager.shared.cancel()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark.circle").imageScale(.large)
                        Text("Cancel")
                    }
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(GKMatch())
    }
}
