load(
    "//build_configuration:variables.bzl",
    "fallacious_build_version",
    "fallacious_short_version_string"
)

load(
    "@build_bazel_rules_apple//apple:versioning.bzl",
    "apple_bundle_version"
)

package(
    default_visibility = [
        "//:__subpackages__"
    ]
)

apple_bundle_version(
    name = "FallaciousAppVersion",
    build_version = fallacious_build_version,
    short_version_string = fallacious_short_version_string
)