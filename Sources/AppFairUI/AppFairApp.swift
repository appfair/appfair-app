// SPDX-License-Identifier: GPL-2.0-or-later
#if !SKIP_BRIDGE
import Foundation
import SwiftUI

/// The name of the current app
let appName = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "Unknown"

/// The current version of the app, using the main bundle's infoDictionary `CFBundleShortVersionString` property on iOS and `android.content.pm.PackageManager` `versionName` on Android.
let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0.0"

/// The bundle identifier of the current app
let appIdentifier = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? "app.unknown"

let appToken = (appIdentifier.split(separator: ".").last?.description ?? "Unknown").replacingOccurrences(of: "_", with: "-")

let appRepository = URL(string: "https://github.com/\(appToken)/\(appToken)")!

/// A top-level settings view that presents a Form with app settings, along with information about the App Fair Project
public struct AppFairSettings<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        Form {
            Section {
                content
            }

            Section {
                NavigationLink("About \(appName)") {
                    Text("App info about \(appName)")
                }
                NavigationLink("About the App Fair Project") {
                    Text("App info")
                }
                NavigationLink("Help and Support") {
                    Text("Support this app…")
                }
                NavigationLink("Translations") {
                    Text("Translate this app…")
                }

                NavigationURLLink(title: LocalizedStringKey("Project Home"), destination: appRepository)
            }
        }
    }
}

/// A `NavigationLink` item that automatically opens the given URL when it is navigated to
///
/// This differs from simply using a `Link`, as it styles the item as a standard navigation element.
struct NavigationURLLink: View {
    let title: LocalizedStringKey
    let destination: URL

    var body: some View {
        // looks right on iOS, but doesn't work on Android
        //Link(destination: destination) {
        //    NavigationLink(title) {
        //
        //    }
        //}
        NavigationLink(title) {
            NavigationURLLinkDestinationView(title: title, destination: destination)
        }
    }

    private struct NavigationURLLinkDestinationView: View {
        @Environment(\.openURL) var openURL
        @Environment(\.dismiss) var dismiss
        let title: LocalizedStringKey
        let destination: URL

        var body: some View {
            Link(title, destination: destination)
                .onAppear {
                    openURL(destination)
                }.task {
                    // pop back up the nav stack when we launch the
                    dismiss()
                }
        }
    }
}

#endif
