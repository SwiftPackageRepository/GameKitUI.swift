//
//  ContentViewModel.swift
//  GKMatchMaker
//
//  Created by smuellner on 28.02.21.
//

import os.log
import Combine
import Foundation
import GameKit
import GameKitUI

class ContentViewModel: ObservableObject {
    
    @Published public var showInvite = false
    @Published public var invite: Invite = Invite.zero
    @Published public var match: GKMatch?
    
    private var cancellable: AnyCancellable?
    
    public init() {
        self.subscribe()
    }
    
    deinit {
        self.unsubscribe()
    }

    func subscribe() {
        self.cancellable = GKMatchOnboarding
            .shared
            .invite
            .sink { (invite) in
                self.invite = invite
              //  self.showInvite = invite.gkInvite != nil
              //  os_log("Player Invited %{public}@", log: OSLog.default, type: .info, invite.gkInvite ?? "NONE")
        }
    }
    
    func unsubscribe() {
        self.cancellable?.cancel()
    }
}
