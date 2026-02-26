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

#if os(iOS) || os(tvOS) || os(visionOS)

import UIKit

///
/// UIViewController helpers to add and remove child view controllers.
///
@nonobjc extension UIViewController {
    
    /// Add child view controller and embed view
    /// - Parameters:
    ///   - viewController: controller to be added as a child controller
    func add(_ child: UIViewController) {
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            child.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            child.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            child.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        child.didMove(toParent: self)
    }
    
    /// Remove child view controller from the parent controller.
    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    /// Remove all child view controller from the parent controller.
    func removeAll() {
        self.children.forEach { (child) in
            child.remove()
        }
    }
}

#endif
