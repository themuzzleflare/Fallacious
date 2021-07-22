load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library"
)

package(
    default_visibility = [
        "//:__subpackages__"
    ]
)

swift_library(
    name = "TinyConstraints",
    module_name = "TinyConstraints",
    srcs = glob([
        "TinyConstraints/*.swift"
    ])
)

swift_library(
    name = "MarqueeLabel",
    module_name = "MarqueeLabel",
    srcs = glob([
        "MarqueeLabel/*.swift"
    ])
)

swift_library(
    name = "SWXMLHash",
    module_name = "SWXMLHash",
    srcs = glob([
        "SWXMLHash/*.swift"
    ])
)

swift_library(
    name = "Macaw",
    module_name = "Macaw",
    srcs = glob([
        "Macaw/**/*.swift"
    ]),
    deps = [
        "SWXMLHash"
    ]
)

swift_library(
    name = "Lottie",
    module_name = "Lottie",
    srcs = glob([
        "Lottie/**/*.swift"
    ])
)