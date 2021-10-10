/////
/// ContentView.swift
/// GKMatchMaker
/// 
/// Created by Sascha Müllner on 03.04.21.
/// Unauthorized copying or usage of this file, via any medium is strictly prohibited.
/// Proprietary and confidential.
/// Copyright © 2021 Webblazer EG. All rights reserved.

import SwiftUI
import GameKit
import GameKitUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 32) {
                    NavigationLink(destination: AuthenticationView()) {
                        Text("Authentication")
                    }
                    NavigationLink(destination: GKGameCenterView()) {
                        Text("Game Center")
                    }
                    NavigationLink(destination: MatchMakingView()) {
                        Text("Match Making")
                    }
                }
            }
            .navigationTitle(Text("GameKit"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
