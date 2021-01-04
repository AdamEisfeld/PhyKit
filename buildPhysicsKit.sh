#!/bin/bash

framework_name="PhysicsKit"
framework_version="1.0.0"

framework_build_dir="Builds"
framework_output_base="$framework_build_dir/$framework_version"

project_name="PhysicsKit.xcodeproj"

build_ios_scheme="PhysicsKit-ios"
build_ios_dir="$framework_output_base/ios"
build_ios_full_path="$build_ios_dir.xcarchive"

build_ios_simulator_scheme="PhysicsKit-ios"
build_ios_simulator_dir="$framework_output_base/ios-simulator"
build_ios_simulator_full_path="$build_ios_simulator_dir.xcarchive"

build_macos_scheme="PhysicsKit-macos"
build_macos_dir="$framework_output_base/macos"
build_macos_full_path="$build_macos_dir.xcarchive"

build_framework_full_path="$framework_build_dir/$framework_version/$framework_name.xcframework"

function deletePath {
  path="$1"
  if [ -d "$path" ]; then rm -Rf "$path"; fi
}

deletePath "$build_ios_full_path"
deletePath "$build_ios_simulator_full_path"
deletePath "$build_macos_full_path"
deletePath "$build_framework_full_path"

echo "Building $framework_name for ios"

xcodebuild archive \
-quiet \
-project "$project_name" \
-scheme "$build_ios_scheme" \
-destination "generic/platform=iOS" \
-archivePath "$build_ios_dir" \
"PRODUCT_NAME=$framework_name" \
"SKIP_INSTALL=NO" \
"BUILD_LIBRARY_FOR_DISTRIBUTION=YES"

echo "Building $framework_name for ios simulator"

xcodebuild archive \
-quiet \
-project "$project_name" \
-scheme "$build_ios_simulator_scheme" \
-destination "generic/platform=iOS Simulator" \
-archivePath "$build_ios_simulator_dir" \
"PRODUCT_NAME=$framework_name" \
"SKIP_INSTALL=NO" \
"BUILD_LIBRARY_FOR_DISTRIBUTION=YES"

echo "Building $framework_name for macos"

xcodebuild archive \
-quiet \
-project "$project_name" \
-scheme "$build_macos_scheme" \
-destination "generic/platform=macOS" \
-archivePath "$build_macos_dir" \
"PRODUCT_NAME=$framework_name" \
"SKIP_INSTALL=NO" \
"BUILD_LIBRARY_FOR_DISTRIBUTION=YES"

echo "Packaging $framework_name"

xcodebuild \
-create-xcframework \
-framework "$build_ios_full_path/Products/Library/Frameworks/$framework_name.framework" \
-framework "$build_ios_simulator_full_path/Products/Library/Frameworks/$framework_name.framework" \
-framework "$build_macos_full_path/Products/Library/Frameworks/$framework_name.framework" \
-output "$build_framework_full_path"

echo "Build complete"
