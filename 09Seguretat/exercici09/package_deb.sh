#!/bin/bash
set -e
umask 022

APP=exercici09
DISPLAY_NAME="Encrypt App"
VERSION=1.0.0
ARCH=amd64
MAINTAINER="cmg"
DESCRIPTION="Aplicació d'encriptació de fitxers amb RSA."
OUTDIR=dist

# 1. Build
flutter build linux --release

# 2. Set up staging dir
STAGING=/tmp/${APP}_staging
rm -rf $STAGING
mkdir -p $STAGING/DEBIAN
mkdir -p $STAGING/usr/local/lib/$APP
mkdir -p $STAGING/usr/local/bin
mkdir -p $STAGING/usr/share/applications
mkdir -p $STAGING/usr/share/icons/hicolor/256x256/apps

# 3. Copy bundle
cp -r build/linux/x64/release/bundle/. $STAGING/usr/local/lib/$APP/

# 4. Launcher wrapper
cat > $STAGING/usr/local/bin/$APP << EOF
#!/bin/bash
exec /usr/local/lib/$APP/$APP "\$@"
EOF

# 5. Desktop entry
cat > $STAGING/usr/share/applications/$APP.desktop << EOF
[Desktop Entry]
Name=$DISPLAY_NAME
Exec=/usr/local/bin/$APP
Icon=$APP
Terminal=false
Type=Application
Categories=Utility;
EOF

# 6. Icon
cp assets/icon.png $STAGING/usr/share/icons/hicolor/256x256/apps/$APP.png

# 7. Installed size
INSTALLED_SIZE=$(du -sk $STAGING/usr | cut -f1)

# 8. Control file
cat > $STAGING/DEBIAN/control << EOF
Package: ${APP//_/-}
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Installed-Size: $INSTALLED_SIZE
Description: $DESCRIPTION
Section: utils
Priority: optional
Depends: libgtk-3-0, libglib2.0-0, libstdc++6, libblkid1, liblzma5
EOF

# 9. postinst
cat > $STAGING/DEBIAN/postinst << 'EOF'
#!/bin/bash
set -e
gtk-update-icon-cache -f -t /usr/share/icons/hicolor 2>/dev/null || true
update-desktop-database /usr/share/applications 2>/dev/null || true
EOF

# 10. md5sums
cd $STAGING
find usr -type f | xargs md5sum > DEBIAN/md5sums
cd - > /dev/null

# 11. Permissions
find $STAGING -type d -exec chmod 755 {} \;
find $STAGING/usr -type f -exec chmod 644 {} \;
chmod 755 $STAGING/usr/local/lib/$APP/$APP
chmod 755 $STAGING/usr/local/bin/$APP
chmod 755 $STAGING/DEBIAN/postinst
chmod 755 $STAGING/DEBIAN

# 12. Build
mkdir -p $OUTDIR
dpkg-deb --build --root-owner-group $STAGING $OUTDIR/${APP}_${VERSION}_${ARCH}.deb

echo "✓ Built: $OUTDIR/${APP}_${VERSION}_${ARCH}.deb"