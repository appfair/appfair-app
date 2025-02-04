// This is free software: you can redistribute and/or modify it
// under the terms of the GNU General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
