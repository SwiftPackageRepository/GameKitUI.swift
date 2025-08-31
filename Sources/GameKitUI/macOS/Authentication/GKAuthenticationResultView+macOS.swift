#if canImport(AppKit)
import SwiftUI
import AppKit

public struct GKAuthenticationResultView: View {
    let viewController: NSViewController

    public init(_ viewController: NSViewController) {
        self.viewController = viewController
    }

    public var body: some View {
        ViewControllerRepresenter { _ in
            viewController
        }
    }
}

#endif
