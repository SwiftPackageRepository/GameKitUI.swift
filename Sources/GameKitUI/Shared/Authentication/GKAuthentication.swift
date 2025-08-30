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

import os.log
import Foundation
import GameKit

@MainActor
public final class GKAuthentication: NSObject, GKLocalPlayerListener {

    public static let shared = GKAuthentication()
    
    private(set) var authenticationError: Error?
    public private(set) var isAuthenticated: Bool = false
    
    private override init() {
        self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
        super.init()
        
        Task {
            if #available(macOS 12.0, iOS 15, *) {
                for await _ in NotificationCenter.default.notifications(named: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName).map({ _ in () }) {
                    self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
                }
            }
        }
    }

    public func authenticate() async throws -> GKLocalPlayer {
        return try await withCheckedThrowingContinuation { continuation in
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if GKLocalPlayer.local.isAuthenticated {
                    continuation.resume(returning: GKLocalPlayer.local)
                    return
                }

                if let error = error {
                    os_log("Authentication failed %{public}@", log: OSLog.authentication, type: .error, error.localizedDescription)
                    self.authenticationError = error
                    continuation.resume(throwing: AuthenticationError.gameKitError(error))
                    return
                }
                
                if let vc = viewController {
                    continuation.resume(throwing: AuthenticationError.uiRequired(vc))
                    return
                }
            }
        }
    }
}
