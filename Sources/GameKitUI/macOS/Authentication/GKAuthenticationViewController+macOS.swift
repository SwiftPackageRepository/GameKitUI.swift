///
/// MIT License
///
/// Copyright (c) 2021 Sascha Müllner
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
/// Created by Sascha Müllner on 28.03.21.

#if os(macOS)

import os.log
import Foundation
import GameKit
import SwiftUI

public class GKAuthenticationViewController: NSViewController {

    private let failed: (Error) -> Void
    private let authenticated: (GKLocalPlayer) -> Void
    private let _loadingViewController = LoadingViewController()

    public init(failed: @escaping (Error) -> Void,
                authenticated: @escaping (GKLocalPlayer) -> Void) {
        self.failed = failed
        self.authenticated = authenticated
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = NSView()
    }
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        self.add(_loadingViewController)
        Task {
            do {
                let player = try await GKAuthentication.shared.authenticate()
                os_log("Player authenticated %{public}@", log: OSLog.authentication, type: .info, player.displayName)
                self.authenticated(player)
            } catch let error as AuthenticationError {
                switch error {
                case .uiRequired(let viewController):
                    self.add(viewController)
                case .gameKitError(let gkError):
                    os_log("Authentication failed %{public}@", log: OSLog.authentication, type: .error, gkError.localizedDescription)
                    self.failed(gkError)
                }
            } catch {
                os_log("Authentication failed %{public}@", log: OSLog.authentication, type: .error, error.localizedDescription)
                self.failed(error)
            }
        }
    }
    
    public override func viewWillDisappear() {
        super.viewWillDisappear()
        self.removeAll()
    }
}

#endif
