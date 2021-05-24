set -e

# Fail if build number not set
if [ -z "$BUILD_NUMBER" ]; then
    echo "Env var 'BUILD_NUMBER' must be set for this script to work correctly"
    exit 1
fi

# If running inside CI login to docker
if [ -z ${IS_CI} ]; then
  echo "Not running in CI, skipping CI setup"
else
  if [ -z $IS_PR ] && [[ $BRANCH == "refs/heads/main" ]]; then
    echo "On main setting PUBLISH=true"
    export PUBLISH=true
  else
    echo "Skipping publish as is from PR: $PR_NUMBER or not 'refs/heads/main' BRANCH: $BRANCH"
  fi
fi

sudo chown -R $(whoami) .

# Set version for release (picked up later by goreleaser)
git tag -f v0.1.$BUILD_NUMBER

export GOVERSION=$(go version)

make lint

if [ -z ${PUBLISH} ]; then
  echo "Running with --skip-publish as PUBLISH not set"
  goreleaser --skip-publish --rm-dist
else
  echo "Publishing release"
  goreleaser
fi