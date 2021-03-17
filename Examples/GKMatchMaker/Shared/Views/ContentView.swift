///
/// ContentView.swift
/// GKMatchMaker
///
/// Created by Sascha Müllner on 24.11.20.

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
                            .primaryButtonStyle()
                    }
                    NavigationLink(destination: MatchMakingView()) {
                        Text("Match Making (Sheet)")
                            .primaryButtonStyle()
                    }
                }
            }
            .navigationBarTitle(Text("GameKit"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
