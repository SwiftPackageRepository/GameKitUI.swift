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
@preconcurrency import Combine
import Foundation
import GameKit
import SwiftUI

@MainActor
public final class GKMatchManager: NSObject {
    
    public static let shared = GKMatchManager()
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("GKAcceptedGameInvite"),
            object: nil,
            queue: nil)
        { [weak self] notification in
            Task {
                await self?.invite.send(Invite.needsToAuthenticate)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("GKPlayerAuthenticationDidChangeNotificationName"),
            object: nil,
            queue: nil)
        { [weak self] notification in
            Task {
                await self?.localPlayer.send(GKLocalPlayer.local)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("GKPlayerDidChangeNotificationName"),
            object: nil,
            queue: nil)
        { [weak self] notification in
            Task {
                await self?.localPlayer.send(GKLocalPlayer.local)
            }
        }
        GKLocalPlayer.local.register(self)
    }
    
    private(set) public var localPlayer = CurrentValueSubject<GKLocalPlayer, Never>(GKLocalPlayer.local)
    private(set) public var match = CurrentValueSubject<Match, Never>(Match.zero)
    private(set) public var invite = CurrentValueSubject<Invite, Never>(Invite.zero)
    
    private var canceled: @Sendable () async -> Void = {}
    private var failed: @Sendable (Error) async -> Void = { _ in }
    private var started: @Sendable (GKMatch) async -> Void = { _ in }
    
    internal func createInvite(invite: GKInvite,
                                 canceled: @escaping @Sendable () async -> Void,
                                 failed: @escaping @Sendable (Error) async -> Void,
                                 started: @escaping @Sendable (GKMatch) async -> Void) -> GKMatchmakerViewController? {
        self.canceled = canceled
        self.failed = failed
        self.started = started
        
        guard GKLocalPlayer.local.isAuthenticated,
              let matchmakerViewController = GKMatchmakerViewController(invite: invite) else {
            GKMatchmaker.shared().cancel()
            Task { await canceled() }
            return nil
        }
        
        matchmakerViewController.matchmakerDelegate = self
        return matchmakerViewController
    }

    internal func createMatchmaker(invite: GKInvite) -> GKMatchmakerViewController? {
        guard GKLocalPlayer.local.isAuthenticated,
              let matchmakerViewController = GKMatchmakerViewController(invite: invite) else {
            GKMatchmaker.shared().cancel()
            return nil
        }
        
        matchmakerViewController.matchmakerDelegate = self
        return matchmakerViewController
    }
    
    internal func createMatchmaker(request: GKMatchRequest,
                                 canceled: @escaping @Sendable () async -> Void,
                                 failed: @escaping @Sendable (Error) async -> Void,
                                 started: @escaping @Sendable (GKMatch) async -> Void) -> GKMatchmakerViewController? {
        self.canceled = canceled
        self.failed = failed
        self.started = started
        guard GKLocalPlayer.local.isAuthenticated,
              let matchmakerViewController = GKMatchmakerViewController(matchRequest: request) else {
            GKMatchmaker.shared().cancel()
            Task { await canceled() }
            return nil
        }
        
        matchmakerViewController.matchmakerDelegate = self
        return matchmakerViewController
    }
    
    public func cancel() {
        GKMatchmaker.shared().cancel()
        self.invite.send(Invite.zero)
        self.match.send(Match.zero)
    }
}

#if os(iOS) || os(tvOS)

extension GKMatchManager: GKMatchmakerViewControllerDelegate {

    public nonisolated func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        let sendableMatch = SendableMatch(match: match)
        Task { [sendableMatch] in
            await viewController.dismiss(animated: true)
            os_log("Matchmaking successful!", log: OSLog.matchmaking, type: .info)
            await MainActor.run { self.match.send(Match(gkMatch: sendableMatch.match)) }
            await self.started(sendableMatch.match)
            await viewController.remove()
        }
    }
    
    public nonisolated func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        Task {
            await viewController.dismiss(animated: true)
            os_log("Matchmaking cancelled!", log: OSLog.matchmaking, type: .error)
            await MainActor.run { self.invite.send(Invite.zero) }
            await MainActor.run { self.match.send(Match.zero) }
            await self.canceled()
            await viewController.remove()
        }
    }
    
    public nonisolated func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        Task { [error] in
            let sendableError = error
            await viewController.dismiss(animated: true)
            os_log("Matchmaking failed: %{public}@", log: OSLog.matchmaking, type: .error, sendableError.localizedDescription)
            await MainActor.run { self.invite.send(Invite.zero) }
            await MainActor.run { self.match.send(Match.zero) }
            await self.failed(sendableError)
            await viewController.remove()
        }
    }
}

#elseif os(macOS)

extension GKMatchManager: GKMatchmakerViewControllerDelegate {

    public nonisolated func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        let sendableMatch = SendableMatch(match: match)
        Task { [sendableMatch] in
            await viewController.dismiss(self)
            os_log("Matchmaking successful!", log: OSLog.matchmaking, type: .info)
            await MainActor.run { self.match.send(Match(gkMatch: sendableMatch.match)) }
            await self.started(sendableMatch.match)
        }
    }
    
    public nonisolated func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        Task {
            await viewController.dismiss(self)
            os_log("Matchmaking cancelled!", log: OSLog.matchmaking, type: .error)
            await MainActor.run { self.invite.send(Invite.zero) }
            await MainActor.run { self.match.send(Match.zero) }
            await self.canceled()
        }
    }
    
    public nonisolated func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        Task { [error] in
            let sendableError = error
            await viewController.dismiss(self)
            os_log("Matchmaking failed: %{public}@", log: OSLog.matchmaking, type: .error, sendableError.localizedDescription)
            await MainActor.run { self.invite.send(Invite.zero) }
            await MainActor.run { self.match.send(Match.zero) }
            await self.failed(sendableError)
        }
    }
}

#endif

extension GKMatchManager: GKLocalPlayerListener {
    
    public nonisolated func player(_ player: GKPlayer,
                didAccept invite: GKInvite) {
        let sendableInvite = SendableInvite(invite: invite)
        Task { [sendableInvite] in
            await MainActor.run {
                self.invite.send(Invite(gkInvite: sendableInvite.invite))
            }
        }
    }
}
