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
/// Created by Sascha Müllner on 22.11.20.
/// Modfied by Sascha Müllner on 17.12.20.

#if os(iOS) || os(tvOS)

import Foundation
import GameKit
import SwiftUI
 
public struct GKMatchmakerView: UIViewControllerRepresentable {

    private let matchRequest: GKMatchRequest
    private var matchmakingMode: Any? = nil
    private let canceled: () -> Void
    private let failed: (Error) -> Void
    private let started: (GKMatch) -> Void

    @available(iOS 14.0, *)
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
    }

    @available(iOS 14.0, *)
    public init(minPlayers: Int,
                maxPlayers: Int,
                inviteMessage: String,
                matchmakingMode: GKMatchmakingMode,
                canceled: @escaping () -> Void,
                failed: @escaping (Error) -> Void,
                started: @escaping (GKMatch) -> Void) {
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = minPlayers
        matchRequest.maxPlayers = maxPlayers
        matchRequest.inviteMessage = inviteMessage
        self.matchRequest = matchRequest
        self.matchmakingMode = matchmakingMode
        self.canceled = canceled
        self.failed = failed
        self.started = started
    }

    public init(matchRequest: GKMatchRequest,
                canceled: @escaping () -> Void,
                failed: @escaping (Error) -> Void,
                started: @escaping (GKMatch) -> Void) {
        self.matchRequest = matchRequest
        self.canceled = canceled
        self.failed = failed
        self.started = started
    }

    public init(minPlayers: Int,
                maxPlayers: Int,
                inviteMessage: String,
                canceled: @escaping () -> Void,
                failed: @escaping (Error) -> Void,
                started: @escaping (GKMatch) -> Void) {
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = minPlayers
        matchRequest.maxPlayers = maxPlayers
        matchRequest.inviteMessage = inviteMessage
        self.matchRequest = matchRequest
        self.canceled = canceled
        self.failed = failed
        self.started = started
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<GKMatchmakerView>) -> MatchmakerViewController {
        if #available(iOS 14.0, *) {
            return self.makeMatchmakerViewControllerForiOS14AndHigher()
        } else {
            return self.makeMatchmakerViewController()
        }
    }

    @available(iOS 14.0, *)
    internal func makeMatchmakerViewControllerForiOS14AndHigher() -> MatchmakerViewController {
        guard let matchmakingMode = self.matchmakingMode as? GKMatchmakingMode else {
            return self.makeMatchmakerViewController()
        }
        return MatchmakerViewController(
            matchRequest: self.matchRequest,
            matchmakingMode: matchmakingMode) {
            self.canceled()
        } failed: { (error) in
            self.failed(error)
        } started: { (match) in
            self.started(match)
        }
    }

    internal func makeMatchmakerViewController() -> MatchmakerViewController {
        return MatchmakerViewController(
            matchRequest: self.matchRequest) {
            self.canceled()
        } failed: { (error) in
            self.failed(error)
        } started: { (match) in
            self.started(match)
        }
    }

    public func updateUIViewController(
        _ uiViewController: MatchmakerViewController,
        context: UIViewControllerRepresentableContext<GKMatchmakerView>) {
    }
}

#endif
