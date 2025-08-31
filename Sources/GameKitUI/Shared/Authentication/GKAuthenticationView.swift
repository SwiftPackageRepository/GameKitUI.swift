import SwiftUI
import GameKit
import OSLog

@MainActor
public struct GKAuthenticationView: View {
    private let failed: (Error) -> Void
    private let authenticated: (GKPlayer) -> Void
    @State private var player: GKPlayer?
    @State private var error: AuthenticationError?

    public init(failed: @escaping (Error) -> Void,
                authenticated: @escaping (GKPlayer) -> Void) {
        self.failed = failed
        self.authenticated = authenticated
    }

    public var body: some View {
        VStack {
            if let player {
                PlayerView(player)
            } else if let error {
                switch error {
                    case .uiRequired(let view):
                        view
                    case .gameKitError(let gkError):
                        Text("GameKit error \(gkError.localizedDescription)")
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await authenticate()
        }
    }

    func authenticate() async {
        do {
            let player = try await GKAuthentication.shared.authenticate()
            os_log("Player authenticated %{public}@", log: OSLog.authentication, type: .info, player.displayName)
            self.player = player
            self.authenticated(player)
        } catch let error as AuthenticationError {
            os_log("Authentication failed %{public}@", log: OSLog.authentication, type: .error, error.localizedDescription)
            self.error = error
            self.failed(error)
        } catch {
            os_log("Authentication failed %{public}@", log: OSLog.authentication, type: .error, error.localizedDescription)
            self.failed(error)
        }
    }
}
