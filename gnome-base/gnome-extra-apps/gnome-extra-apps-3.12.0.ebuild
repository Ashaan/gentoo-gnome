# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-extra-apps/gnome-extra-apps-3.10.0.ebuild,v 1.7 2014/03/09 11:58:28 pacho Exp $

EAPI="5"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="http://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games +shotwell +tracker"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# New package
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/gnome-logs-${PV}
	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-3.10
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-power-manager-${PV}
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweak-tool-${PV}
	>=gnome-extra/gucharmap-${PV}:2.90
	>=gnome-extra/sushi-3.11
	>=mail-client/evolution-${PV}
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-${PV}
	>=media-sound/gnome-sound-recorder-${PV}
	>=media-video/cheese-${PV}
	>=net-misc/vinagre-${PV}
	>=net-misc/vino-${PV}
	>=sys-apps/baobab-${PV}
	>=www-client/epiphany-${PV}

	games? (
		>=games-arcade/gnome-nibbles-${PV}
		>=games-arcade/gnome-robots-${PV}
		>=games-board/aisleriot-${PV}
		>=games-board/four-in-a-row-${PV}
		>=games-board/gnome-chess-${PV}
		>=games-board/gnome-mahjongg-${PV}
		>=games-board/gnome-mines-${PV}
		>=games-board/iagno-${PV}
		>=games-board/tali-${PV}
		>=games-puzzle/five-or-more-${PV}
		>=games-puzzle/gnome-klotski-${PV}
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-tetravex-${PV}
		>=games-puzzle/lightsoff-${PV}
		>=games-puzzle/quadrapassel-${PV}
		>=games-puzzle/swell-foop-${PV} )
	shotwell? ( >=media-gfx/shotwell-0.15 )
	tracker? (
		>=app-misc/tracker-0.16
		>=gnome-extra/gnome-documents-${PV} )
"
DEPEND=""
S=${WORKDIR}
