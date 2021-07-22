load(
    "//bazel-utils:plist_fragment.bzl",
    "plist_fragment"
)

load(
    "//build_configuration:variables.bzl",
    "fallacious_team_id",
    "fallacious_bundle_id",
    "enable_cloudkit_production_environment",
    "enable_appstore_build"
)

load(
    "@build_bazel_rules_apple//apple:resources.bzl",
    "apple_bundle_import"
)

load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library"
)

load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_application"
)

package(
    default_visibility = [
        "//:__subpackages__"
    ]
)

cloudkit_fragment = """
<key>com.apple.developer.icloud-services</key>
<array>
    <string>CloudKit</string>
</array>
<key>com.apple.developer.icloud-container-identifiers</key>
<array>
    <string>iCloud.{container_identifier}</string>
</array>
<key>com.apple.developer.icloud-container-environment</key>
<string>{cloudkit_environment}</string>
""".format(
    container_identifier = fallacious_bundle_id,
    cloudkit_environment = "Production" if enable_cloudkit_production_environment else "Development"
)

associated_domains_fragment = """
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:fallacious.tavitian.cloud</string>
</array>
"""

aps_fragment = """
<key>aps-environment</key>
<string>{aps_environment}</string>
""".format(
    aps_environment = "production" if enable_appstore_build else "development"
)

app_groups_fragment = """
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.{bundle_identifier}</string>
    </array>
    <key>application-identifier</key>
    <string>{team_identifier}.{bundle_identifier}</string>
""".format(
    bundle_identifier = fallacious_bundle_id,
    team_identifier = fallacious_team_id
)

plist_fragment(
    name = "FallaciousEntitlements",
    extension = "entitlements",
    template = "".join([
        aps_fragment,
        app_groups_fragment,
        associated_domains_fragment,
        cloudkit_fragment
    ])
)

filegroup(
    name = "FallaciousAppIcons",
    srcs = glob([
        "AppIcon.xcassets/**"
    ], exclude = ["AppIcon.xcassets/**/.*"])
)

filegroup(
    name = "FallaciousAssets",
    srcs = glob([
        "Assets.xcassets/**"
    ], exclude = ["Assets.xcassets/**/.*"])
)

filegroup(
    name = "FallaciousResources",
    srcs = glob([
        "Resources/**"
    ], exclude = ["Resources/**/.*"])
)

apple_bundle_import(
    name = "FallaciousSettingsBundle",
    bundle_imports = glob([
        "Settings.bundle/*.plist"
    ])
)

swift_library(
    name = "FallaciousCore",
    module_name = "FallaciousCore",
    srcs = glob([
        "Sources/**/*.swift"
    ]),
    data = [
        "FallaciousAssets",
        "FallaciousResources"
    ],
    deps = [
        "//Packages:TinyConstraints",
        "//Packages:MarqueeLabel",
        "//Packages:Macaw",
        "//Packages:Lottie"
    ]
)

ios_application(
    name = "Fallacious",
    bundle_name = "Fallacious",
    bundle_id = fallacious_bundle_id,
    minimum_os_version = "14.0",
    version = "//Resources:FallaciousAppVersion",
    provisioning_profile = "Production.mobileprovision" if enable_appstore_build else "Development.mobileprovision",
    families = [
        "iphone",
        "ipad"
    ],
    infoplists = [
        "Info.plist"
    ],
    entitlements = "FallaciousEntitlements.entitlements",
    settings_bundle = "FallaciousSettingsBundle",
    launch_storyboard = "LaunchScreen.storyboard",
    app_icons = [
        "FallaciousAppIcons"
    ],
    deps = [
        "FallaciousCore"
    ],
    extensions = [
        "//Stickers:FallaciousStickers"
    ]
)