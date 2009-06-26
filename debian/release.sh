#!/bin/sh -e

PKG="byobu"
MAJOR=2

error() {
	echo "ERROR: $@"
	exit 1
}

head -n1 debian/changelog | grep "karmic" || error "This version must be ready for 'karmic'"

# Tag the release in bzr
minor=`head -n1 debian/changelog | sed "s/^.*($MAJOR.//" | sed "s/-.*$//"`
bzr tag --delete "$MAJOR.$minor" || true
bzr tag "$MAJOR.$minor"
bzr commit -m 'releasing $MAJOR.$minor'

# Sign the tarball
gpg --armor --sign --detach-sig ../"$PKG"_*.orig.tar.gz

# Create the rpm export
sudo alien --to-rpm ../$PKG"_"$MAJOR.$minor"_all.deb"
mv -f *.rpm ..
rsync -aP ../*.rpm kirkland@people.ubuntu.com:~kirkland/public_html/$PKG/rpm

# Create the tarball export
$PKG-export -c light -f /tmp/$PKG-export.tar.gz
rsync -aP /tmp/$PKG-export.tar.gz kirkland@people.ubuntu.com:~kirkland/public_html

# Open the next release for development
nextminor=`expr $minor + 1`
dch -v "$MAJOR.$nextminor" "UNRELEASED"
sed -i "s/$MAJOR.$nextminor) .*;/$MAJOR.$nextminor) unreleased;/" debian/changelog
sed -i "s/^Version:.*$/Version:        $MAJOR.$nextminor/" rpm/$PKG.spec
sed -i "s%^Source0:.*$%Source0:        http://code.launchpad.net/$PKG/trunk/$MAJOR.$nextminor/+download/byobu_$MAJOR.$nextminor.orig.tar.gz%" rpm/$PKG.spec
bzr commit -m 'opening $MAJOR.$nextminor'

echo
echo "# To upload PPA packages:"
echo "  dput $PKG-ppa ../*ppa*changes"
echo
echo "# To push:"
echo "  bzr push lp:$PKG"
echo
echo "# Publish tarball at:"
echo "  https://launchpad.net/$PKG/trunk/+addrelease"
echo
echo "# Upload to Ubuntu:"
echo "  dput ../${PKG}_${MAJOR}.${minor}-0ubuntu1_source.changes"
echo
echo
