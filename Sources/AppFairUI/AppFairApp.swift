// SPDX-License-Identifier: GPL-2.0-or-later
#if !SKIP_BRIDGE
import Foundation
import SwiftUI
import SkipKit

/// The name of the current app
let appName = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "Unknown"

/// The current version of the app, using the main bundle's infoDictionary `CFBundleShortVersionString` property on iOS and `android.content.pm.PackageManager` `versionName` on Android.
let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0.0"

/// The bundle identifier of the current app
let appIdentifier = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? "app.unknown"

let appToken = (appIdentifier.split(separator: ".").last?.description ?? "Unknown").replacingOccurrences(of: "_", with: "-")

// FIXME: this only works in cases where the Bundle ID matches the
let appRepository = URL(string: "https://github.com/\(appToken)/\(appToken)")!

/// A top-level settings view that presents a Form with app settings, along with information about the App Fair Project.
///
/// If a `bundle` is provided that contains an SPDX SBOM resource for the current platform
/// (`sbom-darwin-ios.spdx.json` on Apple, `sbom-linux-android.spdx.json` on Android), the
/// settings view also exposes a "Bill of Materials" navigation entry that opens an
/// `SBOMView` for the bundled dependencies and their licenses.
public struct AppFairSettings<Content: View>: View {
    let content: Content
    let bundle: Bundle?

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.bundle = nil
    }

    public init(bundle: Bundle?, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.bundle = bundle
    }

    public var body: some View {
        NavigationStack {
            Form {
                content

                Section {
                    //NavigationLink("About \(appName)") {
                    //    Text("App info about \(appName)")
                    //}
                    //NavigationLink("About the App Fair Project") {
                    //    Text("App info")
                    //}
                    //NavigationLink("Help and Support") {
                    //    Text("Support this app…")
                    //}
                    //NavigationLink("Translations") {
                    //    Text("Translate this app…")
                    //}

                    if let bundle = bundle, SBOMView.bundleContainsSBOM(bundle) {
                        NavigationLink("Bill of Materials") {
                            SBOMView(bundle: bundle)
                        }
                    }

                    NavigationURLLink(title: LocalizedStringKey("Project Home"), destination: appRepository)
                }
            }
            .navigationTitle("\(appName) \(appVersion)")
        }
    }
}

/// A button that opens the given URL in an embedded browser (SFSafariViewController on iOS, Chrome Custom Tabs on Android).
struct NavigationURLLink: View {
    let title: LocalizedStringKey
    let destination: URL
    @State private var isPresented = false

    var body: some View {
        // looks right on iOS, but doesn't work on Android
        Link(destination: destination) {
            NavigationLink(title) {
                NavigationURLLinkDestinationView(title: title, destination: destination)
            }
        }
//        NavigationLink(title) {
//            NavigationURLLinkDestinationView(title: title, destination: destination)
//        }
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
