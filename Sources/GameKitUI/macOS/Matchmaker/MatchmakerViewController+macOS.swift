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

import Combine
import Foundation
import GameKit
import SwiftUI

public class MatchmakerViewController: NSViewController, GKMatchDelegate, GKLocalPlayerListener {
    
    private let matchRequest: GKMatchRequest
    private var matchmakingMode: Any? = nil
    private let canceled: () -> Void
    private let failed: (Error) -> Void
    private let started: (GKMatch) -> Void
    private var cancellable: AnyCancellable?
    private let loadingViewController = LoadingViewController()
    
    @available(macOS 11.0, *)
    public init(matchRequest: GKMatchRequest,
                matchmakingMode: GKMatchmakingMode,
                canceled: @escaping () -> Void,
                failed: @escaping (Error) -> Void,
                started: @escaping (GKMatch) -> Void) {
        self.matchRequest = matchRequest
        self.matchmakingMode = matchmakingMode
        self.canceled = canceled
        self.failed = failed
        self.started = started
        super.init(nibName: nil, bundle: nil)
    }

    public init(matchRequest: GKMatchRequest,
                canceled: @escaping () -> Void,
                failed: @escaping (Error) -> Void,
                started: @escaping (GKMatch) -> Void) {
        self.matchRequest = matchRequest
        self.canceled = canceled
        self.failed = failed
        self.started = started
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = NSView()
        self.view.setBoundsSize(NSSize(width: 800, height: 600))
    }
    
    public func subscribe() {
        self.cancellable = GKMatchManager
            .shared
            .invite
            .sink { (invite) in
                self.showInvite(invite: invite)
        }
    }
    
    public func showInvite(invite: Invite) {
        
        guard let invite = invite.gkInvite else { return }
        
        if let viewController = GKMatchManager.shared.createInvite(invite: invite,
                                                                     canceled: self.canceled,
                                                                     failed: self.failed,
                                                                     started: self.started) {
            self.add(viewController)
        } else {
            self.canceled()
        }
    }
    
    public func unsubscribe() {
        self.cancellable?.cancel()
    }
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        self.add(loadingViewController)
        if GKLocalPlayer.local.isAuthenticated {
            self.showMatchmakerViewController()
        } else {
            self.showAuthenticationViewController()
        }
        self.subscribe()
    }
    
    public override func viewWillDisappear() {
        super.viewWillDisappear()
        self.removeAll()
        self.unsubscribe()
    }
    
    public func showAuthenticationViewController() {
        let authenticationViewController = GKAuthenticationViewController { (error) in
            self.failed(error)
        } authenticated: { (player) in
            self.showMatchmakerViewController()
        }
        self.add(authenticationViewController)
    }
    
    public func showMatchmakerViewController() {
        if let viewController = GKMatchManager.shared.createMatchmaker(request: self.matchRequest,
                                                                     canceled: self.canceled,
                                                                     failed: self.failed,
                                                                     started: self.started) {
            
            if #available(macOS 11.0, *) {
                viewController.matchmakingMode = self.matchmakingMode as? GKMatchmakingMode ?? .default
            }
            
            self.add(viewController)
        } else {
            self.canceled()
        }
    }
}

#endif
