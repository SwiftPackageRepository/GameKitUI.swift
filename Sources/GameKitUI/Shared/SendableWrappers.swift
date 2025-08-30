@preconcurrency import GameKit

public struct SendableMatch: @unchecked Sendable {
    public let match: GKMatch
}

public struct SendableInvite: @unchecked Sendable {
    public let invite: GKInvite
}
