///
/// ContentView.swift
/// GKMatchMaker
///
/// Created by Sascha Müllner on 24.11.20.

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 32) {
                    NavigationLink(destination: SinglePlayerView()) {
                        Text("Single Player")
                            .primaryButtonStyle()
                    }
                    NavigationLink(destination: MatchMakingView()) {
                        Text("Multi Player")
                            .primaryButtonStyle()
                    }
                }
            }
            .navigationBarTitle(Text("Match Making"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
