EAPI=8

CMAKE_BUILD_TYPE=Release

DESCRIPTION="Alternative Minecraft Launcher"
HOMEPAGE="polymc.org"
SRC_URI="https://gerzac1002.de/gz-custom/games-action/polymc/files/polymc-5.1.tar.gz"
LICENSE="GPL-3"
SLOT="0"
IUSE="+lto"
KEYWORDS="amd64 x86"

inherit cmake
CMAKE_MAKEFILE_GENERATOR="ninja"

#inherit git-r3
#EGIT_REPO_URI="https://github.com/polymc/polymc.git"
#EGIT_MIN_CLONE_TYPE="single+tags"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="5.1"
#EGIT_BRANCH="${PV}"

MIN_QT="5.12.0"
QT_SLOT=5

QT_DEPS="
	>=dev-qt/qtgui-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtbase-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtcore-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qttools-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtnetwork-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtchooser-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtcharts-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtconcurrent-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qttest-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtwidgets-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtxml-${MIN_QT}:${QT_SLOT}
"

BDEPEND="
	kde-frameworks/extra-cmake-modules:5
"

DEPEND="
	${QT_DEPS}
	sys-libs/zlib
	dev-util/cmake
	|| ( dev-java/openjdk dev-java/openjdk-bin )
	media-libs/libglvnd
"

RDEPEND="
	${DEPEND}
	>=virtual/jre-1.8.0:*
	virtual/opengl
"

src_prepare() {
	cmake_src_prepare
	sed -i -e 's/-Werror//' -e 's/-D_FORTIFY_SOURCE=2//' CMakeLists.txt || die 'Failed to remove -Werror and -D_FORTIFY_SOURCE via sed'
}

src_configure() {
	local cmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DENABLE_LTO=$(usex lto)
		-DLauncher_APP_BINARY_NAME="${PN}"
		-DLauncher_QT_VERSION_MAJOR=${QT_SLOT}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
