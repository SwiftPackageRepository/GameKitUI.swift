///
/// GKAuthenticationView.swift
/// 
/// Created by Sascha Müllner on 21.11.20.

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

    public let state: ((GKAuthenticationState) -> ())
    public let failed: ((Error) -> ())
    public let authenticated: ((String) -> ())

    public func makeUIViewController(context: UIViewControllerRepresentableContext<GKAuthenticationView>) -> GKAuthenticationViewController {
        let authenticationViewController = GKAuthenticationViewController { (state) in
            self.state(state)
        } failed: { (error) in
            self.failed(error)
        } authenticated: { (playerName) in
            self.authenticated(playerName)
        }
        return authenticationViewController
    }

    public func updateUIViewController(_ uiViewController: GKAuthenticationViewController, context: UIViewControllerRepresentableContext<GKAuthenticationView>) {
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GKAuthenticationViewController.authenticationChanged),
                                               name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName,
                                               object: nil)
        self.authenticate()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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

        GKLocalPlayer.local.authenticateHandler = { vc, error in

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

            guard let vc = vc else { return }

            self.addChild(vc)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(vc.view)

            NSLayoutConstraint.activate([
                vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                vc.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
        }
    }
}
