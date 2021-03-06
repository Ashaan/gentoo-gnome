# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gnome-maps/gnome-maps-3.12.2.ebuild,v 1.2 2014/07/22 10:53:23 ago Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="A map application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Maps"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

RDEPEND="
	>=app-misc/geoclue-1.99.3:2.0
	>=dev-libs/gjs-1.39
	>=dev-libs/gobject-introspection-0.10.1
	>=dev-libs/glib-2.39.3:2
	media-libs/clutter-gtk:1.0[introspection]
	media-libs/clutter:1.0[introspection]
	media-libs/cogl:1.0[introspection]
	media-libs/libchamplain:0.12[introspection]
	net-libs/libsoup:2.4[introspection]
	sci-geosciences/geocode-glib[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.10:3[introspection]
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
}
