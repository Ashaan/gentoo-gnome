# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gconf-editor/gconf-editor-3.0.1-r1.ebuild,v 1.5 2014/02/22 21:53:03 pacho Exp $

EAPI=5
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="An editor to the GNOME config system"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-3.15.0:3
	>=gnome-base/dconf-0.24
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	sys-devel/gettext
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	~app-text/docbook-xml-dtd-4.1.2
"
