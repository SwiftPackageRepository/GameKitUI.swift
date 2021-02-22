///
/// ContentView.swift
/// MatchMaking
///
/// Created by Sascha Müllner on 24.11.20.

import SwiftUI
struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .center, spacing: 32) {
                    NavigationLink(destination: SinglePlayerView()) {
                        Text("Single Player")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(40)
                            .background(Color("ButtonColor"))
                            .cornerRadius(40)
                            .foregroundColor(Color("ButtonTextColor"))
                    }
                    NavigationLink(destination: MatchMakingView()) {
                        Text("Multi Player")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(40)
                            .background(Color("ButtonColor"))
                            .cornerRadius(40)
                            .foregroundColor(Color("ButtonTextColor"))
                        
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle(Text("Match Making"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
