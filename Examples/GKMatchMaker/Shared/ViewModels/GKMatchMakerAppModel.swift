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
/// Created by Sascha Müllner on 24.11.20.

import os.log
import Foundation
import GameKit
import GameKitUI

@MainActor
class GKMatchMakerAppModel {

    public var showAlert = false
    public var alertTitle: String = ""
    public var alertMessage: String = ""

    public var showAuthentication = false
    public var showInvite = false
    public var showMatch = false
    public var invite: Invite = Invite.zero {
        didSet {
            self.showInvite = invite.gkInvite != nil
            self.showAuthentication = invite.needsToAuthenticate ?? false
        }
    }
    public var gkMatch: GKMatch? {
        didSet {
            self.showInvite = false
            self.showMatch = true
        }
    }

    public init() {
        self.subscribe()
        /*
        NotificationCenter.default.addObserver(forName: nil, object: nil, queue: nil) { notification in
            os_log("Notification found with:\r\n name:%{public}@\r\nobject:%{public}\r\nuserInfo: %{public})",
                   log: .default,
                   type: .info,
                   String(describing: notification.name),
                   String(describing: notification.object),
                   String(describing: notification.userInfo)
            )
        }
 */
    }

    @MainActor func subscribe() {
        Task {
            for await invite in GKMatchManager.shared.invite {
                self.invite = invite
            }
        }
        Task {
            for await match in GKMatchManager.shared.match {
                self.gkMatch = match.gkMatch?.match
            }
        }
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}
