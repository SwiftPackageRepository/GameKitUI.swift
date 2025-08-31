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
/// Created by Sascha Müllner on 23.02.21.

#if os(iOS) || os(tvOS)

import SwiftUI
import UIKit

public struct ViewControllerRepresenter<ViewController: UIViewController, Coordinator>: UIViewControllerRepresentable {
    private let makeCoordinatorHandler: @MainActor () -> Coordinator
    private let makeViewControllerHandler: @MainActor (Context) -> ViewController
    private let updateViewControllerHandler: @MainActor (ViewController, Context) -> Void
    private let sizeThatFitsHandler: @MainActor (ProposedViewSize, ViewController, Context) -> CGSize?

    public init(
        makeCoordinator: @escaping @MainActor () -> Coordinator = { () },
        makeViewController: @escaping @MainActor (Context) -> ViewController,
        updateViewController: @escaping @MainActor (ViewController, Context) -> Void = { _, _ in },
        sizeThatFits: @escaping @MainActor (ProposedViewSize, ViewController, Context) -> CGSize? = { _, _, _ in nil }
    ) {
        self.makeCoordinatorHandler = makeCoordinator
        self.makeViewControllerHandler = makeUIViewController
        self.updateViewControllerHandler = updateUIViewController
        self.sizeThatFitsHandler = sizeThatFits
    }

    public func makeCoordinator() -> Coordinator {
        makeCoordinatorHandler()
    }

    public func makeUIViewController(context: Context) -> ViewController {
        makeViewControllerHandler(context)
    }

    public func updateUIViewController(_ viewController: ViewController, context: Context) {
        updateViewControllerHandler(viewController, context)
    }

    @MainActor
    public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: ViewController, context: Context) -> CGSize? {
        sizeThatFitsHandler(proposal, uiViewController, context)
    }
}

#endif
