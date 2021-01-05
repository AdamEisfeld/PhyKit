#!/bin/sh

release_notes=`cat RELEASENOTES.txt`
podspec_path="PhysicsKit.podspec"
framework_version="$1"

function updatePodspec {

  i_podspec_path="$1"
  i_version="$2"
  version_string="automaticVersion = '$i_version'"

  echo "Updating podspec version to $i_version"

  sed -i '' "1s/.*/${version_string}/" "$i_podspec_path"

}

function updateGit {

  i_commit_message="$1"
  i_version_tag="$2"

  # Stage all changes
  git add -A

  # Commit and push changes
  git commit -e
  git push -u origin HEAD

  # Delete current version tag from any commits if it exists
  # git tag -d "$framework_version"
  # git fetch
  # git push origin --delete "$framework_version"
  # git tag -d "$framework_version"

  # Update tag
  git tag -a "$i_version_tag" -m "Automatically updating tag to $i_version_tag"
  git push origin "$i_version_tag"

}

updatePodspec $podspec_path $framework_version
updateGit $release_notes $framework_version
