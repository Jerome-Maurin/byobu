#!/bin/sh -e

PKG="byobu"
MAJOR=2

error() {
	echo "ERROR: $@"
	exit 1
}

head -n1 debian/changelog | grep "unreleased" || error "This version must be 'unreleased'"

./debian/rules release-upstream
bzr bd
sed -i "s/) unreleased;/-0ubuntu1~ppa1) hardy;/" debian/changelog
bzr bd -S
sed -i "s/ppa1) hardy;/ppa2) intrepid;/" debian/changelog
bzr bd -S
sed -i "s/ppa2) intrepid;/ppa3) jaunty;/" debian/changelog
bzr bd -S
sed -i "s/~ppa3) jaunty;/) karmic;/" debian/changelog
bzr bd -S

echo
echo
echo "# Test this build:"
echo "  sudo dpkg -i ../*.deb"
echo
echo "# If everything looks good, release:"
echo "  ./debian/release.sh"
echo
echo
