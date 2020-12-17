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
/// Created by Sascha Müllner on 21.11.20.
/// Modfied by Sascha Müllner on 17.12.20. 

import Foundation
import GameKit
import SwiftUI

public enum GKAuthenticationState {
    case started
    case failed
    case deauthenticated
    case succeeded
}

public struct GKAuthenticationError {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension GKAuthenticationError: LocalizedError {
    public var errorDescription: String? { return message }
}

public struct GKAuthenticationView: UIViewControllerRepresentable {

    private let stateChanged: ((GKAuthenticationState) -> Void)
    private let failed: ((Error) -> Void)
    private let authenticated: ((String) -> Void)

    public init(stateChanged: @escaping ((GKAuthenticationState) -> Void),
                failed: @escaping ((Error) -> Void),
                authenticated: @escaping ((String) -> Void)) {
        self.stateChanged = stateChanged
        self.failed = failed
        self.authenticated = authenticated
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<GKAuthenticationView>) -> GKAuthenticationViewController {
        let authenticationViewController = GKAuthenticationViewController { (state) in
            self.stateChanged(state)
        } failed: { (error) in
            self.failed(error)
        } authenticated: { (playerName) in
            self.authenticated(playerName)
        }
        return authenticationViewController
    }

    public func updateUIViewController(
        _ uiViewController: GKAuthenticationViewController,
        context: UIViewControllerRepresentableContext<GKAuthenticationView>) {
    }
}

public class GKAuthenticationViewController: UIViewController {

    let stateChanged: (GKAuthenticationState) -> Void
    let failed: (Error) -> Void
    let authenticated: (String) -> Void

    public init(stateChanged: @escaping (GKAuthenticationState) -> Void,
                failed: @escaping (Error) -> Void,
                authenticated: @escaping (String) -> Void) {
        self.stateChanged = stateChanged
        self.failed = failed
        self.authenticated = authenticated
        super.init(nibName: nil, bundle: nil)
        // Setup internal observer for GameKit authentication changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GKAuthenticationViewController.authenticationChanged),
            name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName,
            object: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.authenticate()
    }

    @objc fileprivate func authenticationChanged() {
        if GKLocalPlayer.local.isAuthenticated {
            self.stateChanged(.succeeded)
            self.authenticated(GKLocalPlayer.local.alias)
        } else {
            self.stateChanged(.deauthenticated)
        }
    }

    private func authenticate() {

        GKLocalPlayer.local.authenticateHandler = { viewController, error in

            if GKLocalPlayer.local.isAuthenticated {
                return
            }

            if let error = error {
                print(error.localizedDescription)
                self.stateChanged(.failed)
                self.failed(error)
                return
            }

            self.stateChanged(.started)

            guard let viewController = viewController else { return }

            self.addChild(viewController)
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(viewController.view)

            NSLayoutConstraint.activate([
                viewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                viewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
        }
    }
}
