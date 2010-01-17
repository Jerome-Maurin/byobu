#!/bin/sh -e

PKG="byobu"

error() {
	echo "ERROR: $@"
	exit 1
}

head -n1 debian/changelog | grep "unreleased" || error "This version must be 'unreleased'"

./debian/rules get-orig-source
if tar -tvf ../byobu_*.orig.tar.gz | egrep "bzr|debian"; then
	echo "ERROR: release tarball has invalid files"
	exit 1
fi
if tar -tvf ../byobu_*.orig.tar.gz | egrep "/bin/|/lib/" | grep -v "rwxr-xr-x"; then
	echo "ERROR: release tarball has binaries with incorrect permissions"
	exit 1
fi

bzr bd
sed -i "s/) unreleased;/-0ubuntu1~ppa1) hardy;/" debian/changelog
bzr bd -S
sed -i "s/ppa1) hardy;/ppa2) intrepid;/" debian/changelog
bzr bd -S
sed -i "s/ppa2) intrepid;/ppa3) jaunty;/" debian/changelog
bzr bd -S
sed -i "s/ppa3) jaunty;/ppa4) karmic;/" debian/changelog
bzr bd -S
sed -i "s/~ppa4) karmic;/) lucid;/" debian/changelog
bzr bd -S

echo
echo
echo "# Test this build:"
echo "  sudo dpkg -Oi ../byobu_*.deb"
echo
echo "# If everything looks good, release:"
echo "  ./debian/release.sh"
echo
echo
