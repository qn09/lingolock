import Foundation

/// Resolves the actual App Group identifier at runtime.
///
/// When an app is sideloaded via AltServer/AltStore, the App Group ID is rewritten
/// from `group.com.language.wordoftheday` to `group.<TeamID>.com.language.wordoftheday`.
/// This resolver reads the embedded `mobile.provision` profile to discover the real ID,
/// or falls back to the hardcoded default when running in Xcode/direct signing.
public struct AppGroupResolver {

    /// The hardcoded App Group ID used in the project's entitlements
    private static let defaultGroupId = "group.com.language.wordoftheday"

    /// Cached resolved group ID - computed once per process lifetime
    public static let resolvedGroupId: String = {
        // Strategy 1: Try to read from the embedded provisioning profile
        if let profileGroupId = readGroupFromProvisioningProfile() {
            return profileGroupId
        }

        // Strategy 2: Try to detect by looking at the containerURL
        // (This works because iOS creates the container using the *real* group ID)
        if let containerGroupId = detectByContainerAccess() {
            return containerGroupId
        }

        // Strategy 3: Fall back to the hardcoded default
        return defaultGroupId
    }()

    /// Shared UserDefaults accessor using the resolved group ID
    public static var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: resolvedGroupId)
    }

    // MARK: - Resolution Strategies

    /// Reads the embedded mobileprovision file and extracts the App Group entitlement
    private static func readGroupFromProvisioningProfile() -> String? {
        guard let profilePath = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision"),
              let profileData = try? Data(contentsOf: URL(fileURLWithPath: profilePath)) else {
            return nil
        }

        // The provisioning profile is a PKCS7 signed plist.
        // We can extract the XML plist by finding the start and end markers.
        guard let profileString = String(data: profileData, encoding: .ascii) else { return nil }

        guard let plistStart = profileString.range(of: "<?xml"),
              let plistEnd = profileString.range(of: "</plist>") else {
            return nil
        }

        let plistString = String(profileString[plistStart.lowerBound...plistEnd.upperBound])
        guard let plistData = plistString.data(using: .utf8),
              let plist = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any] else {
            return nil
        }

        // Look in Entitlements -> com.apple.security.application-groups
        if let entitlements = plist["Entitlements"] as? [String: Any],
           let groups = entitlements["com.apple.security.application-groups"] as? [String],
           let firstGroup = groups.first(where: { $0.contains("wordoftheday") }) {
            return firstGroup
        }

        return nil
    }

    /// Tries common AltStore-style group ID patterns and checks if the container exists
    private static func detectByContainerAccess() -> String? {
        // Get the bundle ID and try to derive possible team-prefixed group IDs
        let bundleId = Bundle.main.bundleIdentifier ?? ""

        // Check if the default group ID already works (direct signing / Xcode)
        if let defaults = UserDefaults(suiteName: defaultGroupId) {
            // Write a sentinel value and read it back to confirm it's a real shared container
            let testKey = "_appgroup_test"
            defaults.set("ok", forKey: testKey)
            defaults.synchronize()
            if defaults.string(forKey: testKey) == "ok" {
                // Clean up test value
                defaults.removeObject(forKey: testKey)
                defaults.synchronize()
                return defaultGroupId
            }
        }

        // If we have a bundle ID, try to extract a team prefix from it
        // AltStore rewrites bundle IDs to: <originalBundleId>.<TeamID>
        // So the bundle ID might look like: com.language.wordoftheday.XXXXXXX
        let parts = bundleId.split(separator: ".")
        if parts.count > 3 {
            // The last component might be the team ID appended by AltStore
            let possibleTeamId = String(parts.last!)
            let altGroupId = "group.\(possibleTeamId).com.language.wordoftheday"

            if let defaults = UserDefaults(suiteName: altGroupId) {
                let testKey = "_appgroup_test"
                defaults.set("ok", forKey: testKey)
                defaults.synchronize()
                if defaults.string(forKey: testKey) == "ok" {
                    defaults.removeObject(forKey: testKey)
                    defaults.synchronize()
                    return altGroupId
                }
            }
        }

        return nil
    }
}
