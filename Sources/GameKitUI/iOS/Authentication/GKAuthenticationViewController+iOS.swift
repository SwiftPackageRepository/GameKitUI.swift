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

#if os(iOS) || os(tvOS) || os(visionOS)

import os.log
import Foundation
import GameKit
import SwiftUI

public class GKAuthenticationViewController: UIViewController {

    let failed: (Error) -> Void
    let authenticated: (GKLocalPlayer) -> Void
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
    
    deinit {
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.add(_loadingViewController)
        GKAuthentication.shared.authenticate { (authenticationViewController) in
            self.add(authenticationViewController)
        } failed: { (error) in
            os_log("Authentication failed %{public}@", log: OSLog.authentication, type: .error, error.localizedDescription)
            self.failed(error)
        } authenticated: { (player) in
            os_log("Player authenticated %{public}@", log: OSLog.authentication, type: .info, player.displayName)
            self.authenticated(player)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.removeAll()
    }
}

#endif
