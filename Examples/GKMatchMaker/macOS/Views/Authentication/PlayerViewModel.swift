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

@MainActor
class PlayerViewModel: ObservableObject {

    let player: GKPlayer

    @Published var displayName: String
    @Published var imageLoaded = false
    @Published var image: SendableImage?

    public init(_ player: GKPlayer) {
        self.player = player
        self.displayName = self.player.displayName
    }

    public func load() {
        Task {
            if let image = await loadImage() {
                self.image = image
                self.imageLoaded = true
            }
        }
    }

    public nonisolated func loadImage() async -> SendableImage? {
        do {
            let photo = try await self.player.loadPhoto(for: .normal)
            return SendableImage(image: photo)
        } catch {
            return nil
        }
    }
}
