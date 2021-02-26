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

import Foundation
import GameKit
import SwiftUI

public final class GKAuthentication: NSObject, GKLocalPlayerListener {

    public static let shared = GKAuthentication()
    
    private override init() {
        self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
        self.isFailed = false
        super.init()
        // Setup internal observer for GameKit authentication changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GKAuthentication.authenticationChanged),
            name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @Published private(set) var authenticationError: Error?
    @Published private(set) var isAuthenticated: Bool
    @Published private(set) var isFailed: Bool = false
    
    @objc fileprivate func authenticationChanged() {
        self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
    }
    
    public func authenticate(authenticationViewController: @escaping (UIViewController) -> Void,
                             failed: @escaping (Error) -> Void,
                             authenticated: @escaping (GKLocalPlayer) -> Void) {
        
        if GKLocalPlayer.local.isAuthenticated {
            authenticated(GKLocalPlayer.local)
            return
        }
        
        if let authenticationError = self.authenticationError {
            failed(authenticationError)
            return
        }
        
        GKLocalPlayer.local.authenticateHandler = { viewController, error in

            if GKLocalPlayer.local.isAuthenticated {
                authenticated(GKLocalPlayer.local)
                return
            }

            if let error = error {
                print(error.localizedDescription)
                self.authenticationError = error
                failed(error)
                return
            }
            authenticationViewController(viewController!)
        }
    }
}
