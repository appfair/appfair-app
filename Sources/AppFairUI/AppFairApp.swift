// SPDX-License-Identifier: GPL-2.0-or-later
#if !SKIP_BRIDGE
import Foundation
import SwiftUI

/// A top-level settings view that presents a Form with app settings, along with information about the App Fair Project
public struct AppFairSettings<Content: View> : View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        Form {
            content
        }
    }
}
#endif
