
<p align="left"><img src="./MetaData/GameKitUILogo-Rounded.png" height="180"/>&nbsp;<img src="./MetaData/GameKitUILogoDark-Rounded.png" height="180"/></p>

# GameKitUI.swift

## GameKit (GameCenter) helper for SwiftUI

GameKitUI is **created and maintaned with ❥** by Sascha Muellner.

---
[![Swift](https://github.com/SwiftPackageRepository/GameKitUI.swift/workflows/Swift/badge.svg)](https://github.com/SwiftPackageRepository/GameKitUI.swift/actions?query=workflow%3ASwift)
[![codecov](https://codecov.io/gh/SwiftPackageRepository/GameKitUI.swift/branch/main/graph/badge.svg)](https://codecov.io/gh/SwiftPackageRepository/GameKitUI.swift)
![Platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey.svg)
[![License](https://img.shields.io/github/license/SwiftPackageRepository/GameKitUI.swift)](https://github.com/SwiftPackageRepository/GameKitUI.swift/blob/main/LICENSE)
![Version](https://img.shields.io/github/v/tag/SwiftPackageRepository/GameKitUI.swift)
[![Swift Version](https://img.shields.io/badge/swift-5.1-orange.svg?style=flat)](https://developer.apple.com/swift)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-orange.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![README](https://img.shields.io/badge/-README-lightgrey)](https://SwiftPackageRepository.github.io/GameKitUI.swift)

## What?
This is a **Swift** package with support for iOS/macOS/tvOS that allows to use GameKit with SwiftUI. 

## Requirements

The latest version of GameKitUI requires:

- Swift 5+
- iOS 13+
- Xcode 11+

## Installation

### Swift Package Manager
Using SPM add the following to your dependencies

``` 'GameKitUI', 'master', 'https://github.com/smuellner/GameKitUI.swift.git' ```

## How to use?

### GameCenter Authentication

To authenticate the player with GameCenter just show the authentication view **GKAuthenticationView**. 

```swift
import SwiftUI
import GameKitUI

struct ContentView: View {
	var body: some View {
		GKAuthenticationView { (state) in
			switch state {
			    case .started:
			    	print("Authentication Started")
			    	break
			    case .failed:
			    	print("Failed")
			    	break
			    case .deauthenticated:
					print("Deauthenticated")
			      	break
			    case .succeeded:
			    	break
			}
		} failed: { (error) in
			print("Failed: \(error.localizedDescription)")
		} authenticated: { (playerName) in
			print("Hello \(playerName)")
		}
	}
}
```

### GameKit MatchMaker

Match making for a live match can be initiated via the **GKMatchMakerView**. 

```swift
import SwiftUI
import GameKitUI

struct ContentView: View {
	var body: some View {
		GKMatchMakerView(
                    minPlayers: 2,
                    maxPlayers: 4,
                    inviteMessage: "Let us play together!"
                ) {
                    print("Player Canceled")
                } failed: { (error) in
                    print("Match Making Failed: \(error.localizedDescription)")
                } started: { (match) in
                    print("Match Started")
                }
	}
}
```


### GameKit TurnBasedMatchmaker

To start a turn based match use **GKTurnBasedMatchmakerView**. 

```swift
import SwiftUI
import GameKitUI

struct ContentView: View {
	var body: some View {
		GKTurnBasedMatchmakerView(
                    minPlayers: 2,
                    maxPlayers: 4,
                    inviteMessage: "Let us play together!"
                ) {
                    print("Player Canceled")
                } failed: { (error) in
                    print("Match Making Failed: \(error.localizedDescription)")
                } started: { (match) in
                    print("Match Started")
                }
	}
}
```

## Documentation
+ [Apple Documentation GameKit](https://developer.apple.com/documentation/gamekit/)
+ [raywenderlich.com: Game Center for iOS: Building a Turn-Based Game](https://www.raywenderlich.com/7544-game-center-for-ios-building-a-turn-based-game)
+ [raywenderlich.com: Game Center Tutorial: How To Make A Simple Multiplayer Game with Sprite Kit: Part 1/2](https://www.raywenderlich.com/3074-game-center-tutorial-for-ios-how-to-make-a-simple-multiplayer-game-part-1-2)
+ [Medium: GameKit Real Time Multiplayer Tutorial](https://link.medium.com/Mwg3mSi4Ebb)


