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
    @Published public var invite: Invite = Invite.zero
    @Published public var match: GKMatch? {
        didSet {
            self.showInvite = false
            self.showMatch = true
        }
    }

    private var cancellable: AnyCancellable?

    public init() {
        self.subscribe()
        NotificationCenter.default.addObserver(forName: nil, object: nil, queue: nil) { notification in
            os_log("Notification found with:\r\n name:%{public}@\r\nobject:%{public}\r\nuserInfo: %{public})",
                   log: .default,
                   type: .info,
                   String(describing: notification.name),
                   String(describing: notification.object),
                   String(describing: notification.userInfo))
        }
    }

    deinit {
        self.unsubscribe()
    }

    func subscribe() {
        self.cancellable = GKMatchManager
            .shared
            .invite
            .sink { (invite) in
                self.invite = invite
                self.showInvite = invite.gkInvite != nil
                self.showAuthentication = invite.needsToAuthenticate ?? false
        }
    }

    func unsubscribe() {
        self.cancellable?.cancel()
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}
