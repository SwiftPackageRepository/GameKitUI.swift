///
/// MIT License
///
/// Copyright (c) 2020 Henrik Storch
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
/// Created by Henrik Storch on 02.10.21.

#if os(iOS) || os(tvOS) || os(visionOS)

import Foundation
import GameKit
import SwiftUI

public struct GKGameCenterView: UIViewControllerRepresentable {

    let viewController: GKGameCenterViewController

    public init(viewController: GKGameCenterViewController = GKGameCenterViewController()) {
        self.viewController = viewController
    }

    public func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let gkVC = viewController
        gkVC.gameCenterDelegate = context.coordinator
        return gkVC
    }

    public func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        return
    }

    public func makeCoordinator() -> GKCoordinator {
        return GKCoordinator(self)
    }
}

public class GKCoordinator: NSObject, GKGameCenterControllerDelegate {
    var view: GKGameCenterView

    init(_ gkView: GKGameCenterView) {
        self.view = gkView
    }

    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

#endif
