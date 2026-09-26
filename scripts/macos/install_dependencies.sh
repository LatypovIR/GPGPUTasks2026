#!/bin/bash

# exit script on failure
set -ev

njobs=`sysctl -n hw.ncpu`
njobs=`expr $njobs + $njobs`

install_prefix=$(brew --prefix)

googletest_version=1.10.0

echo "Downloading sources"
curl --fail --location --retry 3 --output release-${googletest_version}.zip \
    https://github.com/google/googletest/archive/refs/tags/release-${googletest_version}.zip

# Alternatively you can install googletest simply via: "brew install googletest" - but if you do - you do it on your own risk (version incompatibility is possible)
echo "Installing googletest"
unzip -oq release-${googletest_version}.zip
rm release-${googletest_version}.zip
pushd googletest-release-${googletest_version}
mkdir -p releasebuild
cd releasebuild
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${install_prefix} \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ..
make -j${njobs} install
popd
rm -rf googletest-release-${googletest_version}
