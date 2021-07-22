load(
	"//build_configuration:variables.bzl",
	"fallacious_bundle_id",
	"enable_appstore_build"
)

load(
	"@build_bazel_rules_apple//apple:ios.bzl",
	"ios_sticker_pack_extension"
)

package(
	default_visibility = [
		"//:__subpackages__"
	]
)

filegroup(
	name = "StickersAssets",
	srcs = glob([
		"Stickers.xcstickers/**"
	], exclude = ["Stickers.xcstickers/**/.*"])
)

ios_sticker_pack_extension(
	name = "FallaciousStickers",
	bundle_name = "FallaciousStickers",
	bundle_id = "{bundle_identifier}.stickers".format(
		bundle_identifier = fallacious_bundle_id
	),
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
	sticker_assets = [
		"StickersAssets"
	]
)