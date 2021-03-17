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
/// Created by Sascha Müllner on 26.02.21.

import os.log
import Combine
import Foundation
import GameKit
import SwiftUI

public final class GKMatchOnboarding: NSObject {
    
    public static let shared = GKMatchOnboarding()
    
    private override init() {
        super.init()
        GKLocalPlayer.local.register(self)
    }
    
    private(set) public var match = CurrentValueSubject<Match, Never>(Match.zero)
    private(set) public var invite = CurrentValueSubject<Invite, Never>(Invite.zero)
    
    private var canceled: () -> Void = {}
    private var failed: (Error) -> Void = { _ in }
    private var started: (GKMatch) -> Void = { _ in }
    
    public func createInvite(invite: GKInvite,
                                 canceled: @escaping () -> Void,
                                 failed: @escaping (Error) -> Void,
                                 started: @escaping (GKMatch) -> Void) -> GKMatchmakerViewController? {
        self.canceled = canceled
        self.failed = failed
        self.started = started
        
        guard GKLocalPlayer.local.isAuthenticated,
              let matchmakerViewController = GKMatchmakerViewController(invite: invite) else {
            canceled()
            return nil
        }
        
        matchmakerViewController.matchmakerDelegate = self
        return matchmakerViewController
    }

    public func createMatchmaker(invite: GKInvite) -> GKMatchmakerViewController? {
        guard GKLocalPlayer.local.isAuthenticated,
              let matchmakerViewController = GKMatchmakerViewController(invite: invite) else {
            return nil
        }
        
        matchmakerViewController.matchmakerDelegate = self
        return matchmakerViewController
    }
    
    public func createMatchmaker(request: GKMatchRequest,
                                 canceled: @escaping () -> Void,
                                 failed: @escaping (Error) -> Void,
                                 started: @escaping (GKMatch) -> Void) -> GKMatchmakerViewController? {
        self.canceled = canceled
        self.failed = failed
        self.started = started
        
        guard GKLocalPlayer.local.isAuthenticated,
              let matchmakerViewController = GKMatchmakerViewController(matchRequest: request) else {
            canceled()
            return nil
        }
        
        matchmakerViewController.matchmakerDelegate = self
        return matchmakerViewController
    }
}

extension GKMatchOnboarding: GKMatchmakerViewControllerDelegate {

    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(
            animated: true,
            completion: {
                self.match.send(Match(gkMatch: match))
                self.started(match)
                viewController.remove()
        })
    }
    
    public func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(
            animated: true,
            completion: {
                self.invite.send(Invite.zero)
                self.match.send(Match.zero)
                self.canceled()
                viewController.remove()
                os_log("Matchmaking cancelled!", log: OSLog.matchmaking, type: .error)
        })
    }
    
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(
            animated: true,
            completion: {
                self.invite.send(Invite.zero)
                self.match.send(Match.zero)
                self.failed(error)
                viewController.remove()
                os_log("Matchmaking failed: %{public}@", log: OSLog.matchmaking, type: .error, error.localizedDescription)
        })
    }
}

extension GKMatchOnboarding: GKLocalPlayerListener {

    public func player(_ player: GKPlayer,
                didAccept invite: GKInvite) {
        os_log("Player invited: %{public}@", log: OSLog.invite, type: .info, invite)
        self.invite.send(Invite(gkInvite: invite))
    }
}