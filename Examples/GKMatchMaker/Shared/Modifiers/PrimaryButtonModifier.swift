///
/// PrimaryButtonModifier.swift
/// GKMatchMaker
///
/// Created by Sascha Müllner on 22.02.21.
///

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.title)
            .padding(40)
            .background(Color("ButtonColor"))
            .cornerRadius(40)
            .foregroundColor(Color("ButtonTextColor"))
    }
}

extension Text {
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
}
