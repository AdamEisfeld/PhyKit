#!/bin/bash

framework_name="PhysicsKit"
framework_build_dir="Framework"
framework_version="$1"

podspec_path="PhysicsKit.podspec"

framework_output_base="$framework_build_dir"

project_path="PhysicsKit.xcodeproj"

build_ios_scheme="PhysicsKit-ios"
build_ios_dir="$framework_output_base/ios"
build_ios_full_path="$build_ios_dir.xcarchive"

build_ios_simulator_scheme="PhysicsKit-ios"
build_ios_simulator_dir="$framework_output_base/ios-simulator"
build_ios_simulator_full_path="$build_ios_simulator_dir.xcarchive"

build_macos_scheme="PhysicsKit-macos"
build_macos_dir="$framework_output_base/macos"
build_macos_full_path="$build_macos_dir.xcarchive"

build_framework_full_path="$framework_build_dir/$framework_name.xcframework"

function deletePath {
  i_path="$1"
  if [ -d "$i_path" ]; then rm -Rf "$i_path"; fi
}

function buildArchive {

  i_destination="$1"
  i_project_path="$2"
  i_archive_name="$3"
  i_scheme="$4"
  i_output_dir="$5"

  echo "Building $i_archive_name archive for $i_destination"

  xcodebuild archive \
  -quiet \
  -project "$i_project_path" \
  -scheme "$i_scheme" \
  -destination "$i_destination" \
  -archivePath "$i_output_dir" \
  "PRODUCT_NAME=$i_archive_name" \
  "SKIP_INSTALL=NO" \
  "BUILD_LIBRARY_FOR_DISTRIBUTION=YES"
}

function buildFramework {

  i_framework_name="$1"
  i_ios_path="$2"
  i_ios_simulator_path="$3"
  i_macos_path="$4"
  i_output_full_path="$5"

  echo "Packaging archives into $i_framework_name.xcframework"

  xcodebuild \
  -create-xcframework \
  -framework "$i_ios_path/Products/Library/Frameworks/$i_framework_name.framework" \
  -framework "$i_ios_simulator_path/Products/Library/Frameworks/$i_framework_name.framework" \
  -framework "$i_macos_path/Products/Library/Frameworks/$i_framework_name.framework" \
  -output "$i_output_full_path"
}

function updatePodspec {

  i_podspec_path="$1"
  i_version="$2"
  version_string="automaticVersion = '$i_version'"

  echo "Updating podspec version to $i_version"

  sed -i '' "1s/.*/${version_string}/" "$i_podspec_path"

}


deletePath "$build_ios_full_path"
deletePath "$build_ios_simulator_full_path"
deletePath "$build_macos_full_path"
deletePath "$build_framework_full_path"

buildArchive \
"generic/platform=iOS" \
"$project_path" \
"$framework_name" \
"$build_ios_scheme" \
"$build_ios_dir"

buildArchive \
"generic/platform=iOS Simulator" \
"$project_path" \
"$framework_name" \
"$build_ios_simulator_scheme" \
"$build_ios_simulator_dir"

buildArchive \
"generic/platform=macOS" \
"$project_path" \
"$framework_name" \
"$build_macos_scheme" \
"$build_macos_dir"

buildFramework "$framework_name" "$build_ios_full_path" "$build_ios_simulator_full_path" "$build_macos_full_path" "$build_framework_full_path"

updatePodspec $podspec_path $framework_version

echo "Build complete"
