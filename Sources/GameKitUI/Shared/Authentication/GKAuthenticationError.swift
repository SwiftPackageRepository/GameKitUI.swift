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
/// Created by Sascha Müllner on 23.02.21.

import Foundation
#if canImport(UIKit)
import UIKit // For UIViewController
#elseif canImport(AppKit)
import AppKit // For NSViewController
#endif

public enum AuthenticationError: Error {
    #if canImport(UIKit)
    case uiRequired(UIViewController)
    #elseif canImport(AppKit)
    case uiRequired(NSViewController)
    #endif
    case gameKitError(Error)

    public var errorDescription: String? {
        switch self {
        #if canImport(UIKit)
        case .uiRequired(let viewController):
            return "GameKit authentication requires UI presentation: \(viewController.description)"
        #elseif canImport(AppKit)
        case .uiRequired(let viewController):
            return "GameKit authentication requires UI presentation: \(viewController.description)"
        #endif
        case .gameKitError(let error):
            return "GameKit authentication failed: \(error.localizedDescription)"
        }
    }
}
