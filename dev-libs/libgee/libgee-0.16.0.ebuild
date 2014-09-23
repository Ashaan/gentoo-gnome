# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgee/libgee-0.14.0.ebuild,v 1.8 2014/09/15 08:18:37 ago Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 vala

DESCRIPTION="GObject-based interfaces and classes for commonly used data structures"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgee"

LICENSE="LGPL-2.1+"
SLOT="0.8"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 ~sh sparc x86 ~x86-linux"
IUSE="+introspection +vala"

# FIXME: add doc support, requires valadoc
RDEPEND="
	>=dev-libs/glib-2.36:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	vala_src_prepare
	DOCS="AUTHORS ChangeLog* MAINTAINERS NEWS README"
	gnome2_src_configure \
		$(use_enable introspection) \
		$(use_enable vala)
}

