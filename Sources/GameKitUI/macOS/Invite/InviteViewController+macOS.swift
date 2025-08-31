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

import Foundation
import GameKit
import SwiftUI

public class InviteViewController: NSViewController, GKMatchDelegate, GKLocalPlayerListener {
    
    private let invite: GKInvite
    private let canceled: @Sendable () async -> Void
    private let failed: @Sendable (Error) async -> Void
    private let started: @Sendable (GKMatch) async -> Void

    public init(invite: GKInvite,
                canceled: @escaping @Sendable () async -> Void,
                failed: @escaping @Sendable (Error) async -> Void,
                started: @escaping @Sendable (GKMatch) async -> Void) {
        self.invite = invite
        self.canceled = { await canceled() }
        self.failed = { await failed($0) }
        self.started = { await started($0) }
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
        Task {
            if GKLocalPlayer.local.isAuthenticated {
                await self.showInviteViewController()
            } else {
                await self.showAuthenticationViewController()
            }
        }
    }
    
    public override func viewWillDisappear() {
        super.viewWillDisappear()
        self.removeAll()
    }
    
    public func showAuthenticationViewController() async {
        /*
        let authenticationViewController = GKAuthenticationViewController { (error) in
            Task { await self.failed(error) }
        } authenticated: { (player) in
            Task { await self.showInviteViewController() }
        }
        self.add(authenticationViewController)
         */
    }
    
    public func showInviteViewController() async {
        if let viewController = GKMatchManager.shared.createInvite(invite: self.invite,
                                                                     canceled: self.canceled,
                                                                     failed: self.failed,
                                                                     started: self.started) {
            
            self.add(viewController)
        } else {
            await self.canceled()
        }
    }
}

#endif
