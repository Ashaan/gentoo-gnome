# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils flag-o-matic gnome2 multilib virtualx multilib-minimal

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="3"
IUSE="aqua broadway cloudprint colord cups examples +introspection test vim-syntax wayland X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )
"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# FIXME: introspection data is built against system installation of gtk+:3
# NOTE: cairo[svg] dep is due to bug 291283 (not patched to avoid eautoreconf)
COMMON_DEPEND="
	>=dev-libs/atk-2.15.1[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.43.4:2[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=media-libs/libepoxy-1.0[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.14[aqua?,glib,svg,X?,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?,X?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.37.3[introspection?,${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info

	cloudprint? (
		>=net-libs/rest-0.7[${MULTILIB_USEDEP}]
		>=dev-libs/json-glib-1.0[${MULTILIB_USEDEP}] )
	colord? ( >=x11-misc/colord-0.1.9:0=[${MULTILIB_USEDEP}] )
	cups? ( >=net-print/cups-1.2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	wayland? (
		>=dev-libs/wayland-1.5.91[${MULTILIB_USEDEP}]
		media-libs/mesa[wayland,${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.2[${MULTILIB_USEDEP}]
	)
	X? (
		>=app-accessibility/at-spi2-atk-2.5.3[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.3[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.3[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-libs/gobject-introspection-common
	>=dev-util/gdbus-codegen-2.38.2
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18.3[${MULTILIB_USEDEP}]
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	X? (
		x11-proto/xextproto[${MULTILIB_USEDEP}]
		x11-proto/xproto[${MULTILIB_USEDEP}]
		x11-proto/inputproto[${MULTILIB_USEDEP}]
		x11-proto/damageproto[${MULTILIB_USEDEP}]
		xinerama? ( x11-proto/xineramaproto[${MULTILIB_USEDEP}] )
	)
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )
	examples? ( media-libs/libcanberra[gtk3] )
"
# gtk+-3.2.2 breaks Alt key handling in <=x11-libs/vte-0.30.1:2.90
# gtk+-3.3.18 breaks scrolling in <=x11-libs/vte-0.31.0:2.90
# >=xorg-server-1.11.4 needed for
#  https://mail.gnome.org/archives/desktop-devel-list/2012-March/msg00024.html
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3
	!<gnome-base/gail-1000
	!<x11-libs/vte-0.31.0:2.90
	>=x11-themes/adwaita-icon-theme-3.14
	X? ( !<x11-base/xorg-server-1.11.4 )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508-r3
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)
"
# librsvg for svg icons (PDEPEND to avoid circular dep), bug #547710
PDEPEND="
	gnome-base/librsvg[${MULTILIB_USEDEP}]
	vim-syntax? ( app-vim/gtk-syntax )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gtk-query-immodules-3.0
)

strip_builddir() {
	local rule=$1
	shift
	local directory=$1
	shift
	sed -e "s/^\(${rule} =.*\)${directory}\(.*\)$/\1\2/" -i $@ \
		|| die "Could not strip director ${directory} from build."
}

src_prepare() {
	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	if ! use test ; then
		# don't waste time building tests
		strip_builddir SRC_SUBDIRS testsuite Makefile.{am,in}

		# the tests dir needs to be build now because since commit
		# 7ff3c6df80185e165e3bf6aa31bd014d1f8bf224 tests/gtkgears.o needs to be there
		# strip_builddir SRC_SUBDIRS tests Makefile.{am,in}
	fi

	if ! use examples; then
		# don't waste time building demos
		strip_builddir SRC_SUBDIRS demos Makefile.{am,in}
		strip_builddir SRC_SUBDIRS examples Makefile.{am,in}
	fi

	# gtk-update-icon-cache is installed by dev-util/gtk-update-icon-cache 
	epatch "${FILESDIR}"/${PN}-3.16.2-remove_update-icon-cache.patch

	epatch_user

	eautoreconf
	gnome2_src_prepare
}

multilib_src_configure() {
	# need libdir here to avoid a double slash in a path that libtool doesn't
	# grok so well during install (// between $EPREFIX and usr ...)
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(use_enable aqua quartz-backend) \
		$(use_enable broadway broadway-backend) \
		$(use_enable cloudprint) \
		$(use_enable colord) \
		$(use_enable cups cups auto) \
		$(multilib_native_use_enable introspection) \
		$(use_enable wayland wayland-backend) \
		$(use_enable X x11-backend) \
		$(use_enable X xcomposite) \
		$(use_enable X xdamage) \
		$(use_enable X xfixes) \
		$(use_enable X xkb) \
		$(use_enable X xrandr) \
		$(use_enable xinerama) \
		--disable-papi \
		--disable-mir-backend \
		--enable-man \
		--with-xml-catalog="${EPREFIX}"/etc/xml/catalog \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		CUPS_CONFIG="${EPREFIX}/usr/bin/${CHOST}-cups-config"

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		local d
		for d in gdk gtk libgail-util; do
			ln -s "${S}"/docs/reference/${d}/html docs/reference/${d}/html || die
		done
	fi
}

multilib_src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die

	unset DBUS_SESSION_BUS_ADDRESS
	unset DISPLAY #527682
	GSETTINGS_SCHEMA_DIR="${S}/gtk" Xemake check
}

multilib_src_install() {
	gnome2_src_install

	# add -framework Carbon to the .pc files, bug #???
	if use aqua ; then
		for i in gtk+-3.0.pc gtk+-quartz-3.0.pc gtk+-unix-print-3.0.pc; do
			sed -e "s:Libs\: :Libs\: -framework Carbon :" \
				-i "${ED%/}"/usr/$(get_libdir)/pkgconfig/$i || die "sed failed"
		done
	fi
}

multilib_src_install_all() {
	insinto /etc/gtk-3.0
	doins "${FILESDIR}"/settings.ini

	dodoc AUTHORS ChangeLog* HACKING NEWS* README*
}

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make immodules.cache belongs to gtk+ alone
		local cache="usr/$(get_libdir)/gtk-3.0/3.0.0/immodules.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}
	multilib_parallel_foreach_abi multilib_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_query_immodules_gtk3 \
			|| die "Update immodules cache failed (for ${ABI})"
	}
	multilib_parallel_foreach_abi multilib_pkg_postinst

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSIONS} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"usr/$(get_libdir)/gtk-3.0/3.0.0/immodules.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
	fi
}
