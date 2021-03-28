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

public struct GKInviteView: NSViewControllerRepresentable {

    private let invite: GKInvite
    private let canceled: () -> Void
    private let failed: (Error) -> Void
    private let started: (GKMatch) -> Void

    public init(invite: GKInvite,
                canceled: @escaping () -> Void,
                failed: @escaping (Error) -> Void,
                started: @escaping (GKMatch) -> Void) {
        self.invite = invite
        self.canceled = canceled
        self.failed = failed
        self.started = started
    }

    public func makeNSViewController(
        context: NSViewControllerRepresentableContext<GKInviteView>) -> InviteViewController {
        
        return InviteViewController(
            invite: self.invite) {
            self.canceled()
        } failed: { (error) in
            self.failed(error)
        } started: { (match) in
            self.started(match)
        }
    }

    public func updateNSViewController(
        _ nsViewController: InviteViewController,
        context: NSViewControllerRepresentableContext<GKInviteView>) {
    }
}

#endif
