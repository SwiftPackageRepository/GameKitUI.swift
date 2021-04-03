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
/// Created by smuellner on 23.02.21.


import Foundation
import Combine
import GameKit
import GameKitUI

class AuthenticationViewModel: ObservableObject {

    @Published public var showModal = false
    @Published public var showAlert = false
    @Published public var isAuthenticated = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    @Published public var currentState: String = "Loading GameKit..."
    @Published public var player: GKPlayer? {
        didSet {
            self.isAuthenticated = self.player != nil
        }
    }
    
    public func load() {
        if self.isAuthenticated {
            return
        }
        self.showAuthenticationModal()
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
    
    public func showAuthenticationModal() {
        self.showModal = true
    }
}
