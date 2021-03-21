///
/// GKMatchMakerAppModel.swift
/// GKMatchMaker
///
/// Created by Sascha Müllner on 24.11.20.

import os.log
import Combine
import Foundation
import GameKit
import GameKitUI

class GKMatchMakerAppModel: ObservableObject {

    @Published public var showAlert = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""

    @Published public var showAuthentication = false
    @Published public var showInvite = false
    @Published public var showMatch = false
    @Published public var invite: Invite = Invite.zero {
        didSet {
            self.showInvite = invite.gkInvite != nil
            self.showAuthentication = invite.needsToAuthenticate ?? false
        }
    }
    @Published public var gkMatch: GKMatch? {
        didSet {
            self.showInvite = false
            self.showMatch = true
        }
    }

    private var cancellableInvite: AnyCancellable?
    private var cancellableMatch: AnyCancellable?

    public init() {
        self.subscribe()
        NotificationCenter.default.addObserver(forName: nil, object: nil, queue: nil) { notification in
            os_log("Notification found with:\r\n name:%{public}@\r\nobject:%{public}\r\nuserInfo: %{public})",
                   log: .default,
                   type: .info,
                   String(describing: notification.name),
                   String(describing: notification.object),
                   String(describing: notification.userInfo)
            )
        }
    }

    deinit {
        self.unsubscribe()
    }

    func subscribe() {
        self.cancellableInvite = GKMatchManager
            .shared
            .invite
            .sink { (invite) in
                self.invite = invite
        }
        self.cancellableMatch = GKMatchManager
            .shared
            .match
            .sink { (match) in
                self.gkMatch = match.gkMatch
        }
    }

    func unsubscribe() {
        self.cancellableInvite?.cancel()
        self.cancellableMatch?.cancel()
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}
