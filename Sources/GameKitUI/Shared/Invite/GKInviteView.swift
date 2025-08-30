import SwiftUI
import GameKit

public struct GKInviteView: View {

    private let invite: GKInvite?
    private let canceled: @Sendable () -> Void
    private let failed: @Sendable (Error) -> Void
    private let started: @Sendable (GKMatch) -> Void

    public init(invite: GKInvite?,
                canceled: @escaping @Sendable () -> Void,
                failed: @escaping @Sendable (Error) -> Void,
                started: @escaping @Sendable (GKMatch) -> Void) {
        self.invite = invite
        self.canceled = canceled
        self.failed = failed
        self.started = started
    }

    public var body: some View {
        if let invite {
            GKInvitePlatformView(invite: invite,
                                 canceled: self.canceled,
                                 failed: self.failed,
                                 started: self.started)
        } else {
            Text("No Invitation.")
        }
    }
}

#Preview {
    GKInviteView(invite: nil) {

    } failed: { error in

    } started: { match in

    }
}
