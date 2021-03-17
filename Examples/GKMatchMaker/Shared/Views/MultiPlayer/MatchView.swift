/////
/// MatchView.swift
/// GKMatchmaker
/// 
/// Created by Sascha Müllner on 17.03.21.
/// Unauthorized copying or usage of this file, via any medium is strictly prohibited.
/// Proprietary and confidential.
/// Copyright © 2021 Webblazer EG. All rights reserved.

import SwiftUI
import GameKit
import GameKitUI

struct MatchView: View {
    var match: GKMatch

    public init(_ match: GKMatch) {
        self.match = match
    }

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack() {
                ForEach(self.match.players, id: \.self) { player in
                    Text(player.displayName)
                        .font(.title)
                        .padding(8)
                }
            }
            .navigationBarTitle(Text("GameKit Match"))
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(GKMatch())
    }
}
