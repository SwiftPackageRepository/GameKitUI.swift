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

#if os(macOS)

import SwiftUI

public struct ViewControllerRepresenter<ViewController: NSViewController, Coordinator>: NSViewControllerRepresentable {
    private let _makeCoordinatorHandler: @MainActor () -> Coordinator
    private let _makeViewControllerHandler: @MainActor (Context) -> ViewController
    private let _updateViewControllerHandler: @MainActor (ViewController, Context) -> Void
    private let _sizeThatFitsHandler: @MainActor (ProposedViewSize, ViewController, Context) -> CGSize?

    public init(
        makeCoordinator: @escaping @MainActor () -> Coordinator = { () },
        makeViewControllerHandler: @escaping @MainActor (Context) -> ViewController,
        updateViewControllerHandler: @escaping @MainActor (ViewController, Context) -> Void = { _, _ in },
        sizeThatFits: @escaping @MainActor (ProposedViewSize, ViewController, Context) -> CGSize? = { _, _, _ in nil }
    ) {
        _makeCoordinatorHandler = makeCoordinator
        _makeViewControllerHandler = makeViewControllerHandler
        _updateViewControllerHandler = updateViewControllerHandler
        _sizeThatFitsHandler = sizeThatFits
    }

    public func makeCoordinator() -> Coordinator {
        _makeCoordinatorHandler()
    }

    public func makeNSViewController(context: Context) -> ViewController {
        _makeViewControllerHandler(context)
    }

    public func updateNSViewController(_ viewController: ViewController, context: Context) {
        _updateViewControllerHandler(viewController, context)
    }

    @MainActor
    public func sizeThatFits(_ proposal: ProposedViewSize, NSViewController: ViewController, context: Context) -> CGSize? {
        _sizeThatFitsHandler(proposal, NSViewController, context)
    }
}

#endif
