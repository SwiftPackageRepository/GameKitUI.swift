#if canImport(UIKit)
import SwiftUI
import UIKit

public struct GKAuthenticationResultView: View {
    let viewController: UIViewController

    public init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    public var body: some View {
        ViewControllerRepresenter { _ in
            viewController
        }
    }
}

#endif
