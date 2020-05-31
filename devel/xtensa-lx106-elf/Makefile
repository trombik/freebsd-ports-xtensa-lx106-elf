# Created by: Craig Leres <leres@freebsd.org>
# $FreeBSD$

PORTNAME=	xtensa-lx106-elf
DISTVERSION=	1.22.0.20200113
#PORTREVISION=	1
CATEGORIES=	devel
MASTER_SITES=	SOURCEWARE/binutils/releases/binutils:source1 \
		GNU/binutils:source1 \
		https://github.com/libexpat/libexpat/releases/download/R_${PORTVERSION:S|.|_|g}/:source2 \
		SF/expat:source2 \
		GCC/releases/gcc-5.2.0:source3 \
		GNU/gdb:source4 \
		GNU/gmp:source5 \
		http://isl.gforge.inria.fr/:source6 \
		GNU/mpc:source7 \
		http://www.mpfr.org/mpfr-3.1.3/:source8 \
		GNU/mpfr:source8 \
		ftp://ftp.invisible-island.net/ncurses/:source9 \
		GNU/ncurses:source9 \
		SOURCEWARE/newlib:source10 \
		ftp://sources.redhat.com/pub/newlib/:source10 \
		http://www.bastoul.net/cloog/pages/download/:source11
DISTFILES=	binutils-2.25.1.tar.bz2:source1 \
		expat-2.1.0.tar.gz:source2 \
		gcc-5.2.0.tar.bz2:source3 \
		gdb-7.10.tar.xz:source4 \
		gmp-6.0.0a.tar.xz:source5 \
		isl-0.14.tar.xz:source6 \
		mpc-1.0.3.tar.gz:source7 \
		mpfr-3.1.3.tar.xz:source8 \
		ncurses-6.0.tar.gz:source9 \
		newlib-2.2.0.tar.gz:source10 \
		cloog-0.18.4.tar.gz:source11
EXTRACT_ONLY=	${DISTNAME}${EXTRACT_SUFX}

MAINTAINER=	leres@FreeBSD.org
COMMENT=	Espressif ESP32 toolchain

LICENSE=	GPLv2 LGPL21
LICENSE_COMB=	multi

BROKEN_aarch64=		fails to configure: cannot compute suffix of object files: cannot compile
BROKEN_armv6=		fails to build: failed in step 'Installing pass-2 core C gcc compiler'
BROKEN_armv7=		fails to build: failed in step 'Installing pass-2 core C gcc compiler'

BUILD_DEPENDS=	bash:shells/bash \
		gawk:lang/gawk \
		git:devel/git \
		gpatch:devel/patch \
		${LOCALBASE}/bin/grep:textproc/gnugrep \
		gperf:devel/gperf \
		gsed:textproc/gsed \
		help2man:misc/help2man \
		makeinfo:print/texinfo \
		wget:ftp/wget

USES=		autoreconf:build bison gmake libtool python:2.7 iconv gettext-runtime
USE_GCC=	7+
USE_GITHUB=	yes
USE_LDCONFIG=	${PREFIX}/${PORTNAME}/libexec/gcc/${PORTNAME}/5.2.0

NO_MTREE=	yes
SUBDIR=		crosstool-NG
TAGNAME=	ca13a26
GH_TUPLE=	espressif:${SUBDIR}:${TAGNAME}
BINARY_ALIAS=	g++=${CXX} gcc=${CC} python=${PYTHON_VERSION}
BUILD_ENV=	CT_ALLOW_BUILD_AS_ROOT_SURE=1 \
		LD_RUN_PATH=${PREFIX}/lib/${CC} \
		${MAKE_ENV:MPATH=*}

.if defined(BATCH)
CT_LOG_PROGRESS_BAR=	n
.else
CT_LOG_PROGRESS_BAR=	y
.endif

post-extract:
	${MKDIR} ${BUILD_WRKSRC}/.build/tarballs
.for F in $(DISTFILES:N$(EXTRACT_ONLY))
	${LN} -s ${DISTDIR}/${F:C/:source[0-9]+$//} \
	    ${BUILD_WRKSRC}/.build/tarballs
.endfor

pre-configure:
	@${REINPLACE_CMD} -e 's/\(GNU bash, version.*4\)/\1|5/' \
		${WRKSRC}/configure.ac
	@${REINPLACE_CMD} \
	    -e 's|%%CT_LOG_PROGRESS_BAR%%|${CT_LOG_PROGRESS_BAR}|g' \
	    ${WRKSRC}/samples/xtensa-lx106-elf/crosstool.config

do-configure:
	cd ${BUILD_WRKSRC} && ./bootstrap
	${PRINTF} "#!/bin/sh\necho '${SUBDIR:tl}-${TAGNAME}'\n" > \
	    ${BUILD_WRKSRC}/version.sh
	${CHMOD} -w+x ${BUILD_WRKSRC}/version.sh
	cd ${BUILD_WRKSRC} && \
	    ./configure --enable-local --with-grep=${LOCALBASE}/bin/grep
	cd ${BUILD_WRKSRC} && \
	    ${SETENV} -uMAKELEVEL -uMAKEFLAGS -u.MAKE.LEVEL.ENV \
	    ${MAKE_CMD} install && ${SETENV} ${BUILD_ENV} ./ct-ng ${PORTNAME}
	${RM} ${WRKSRC}/samples/xtensa-lx106-elf/crosstool.config.bak \
		${WRKSRC}/samples/xtensa-lx106-elf/crosstool.config.orig

do-build:
	cd ${BUILD_WRKSRC} && ${SETENV} ${BUILD_ENV} ./ct-ng build
	cd ${BUILD_WRKSRC}/builds/${PORTNAME} && \
	    ${CHMOD} +w . lib && \
	    ${RM} build.log.bz2 lib/charset.alias && \
	    ${CHMOD} -w . lib

do-install:
	cd ${BUILD_WRKSRC}/builds && \
	    ${COPYTREE_BIN} ${PORTNAME} ${STAGEDIR}${PREFIX}
	${FIND} ${STAGEDIR}${PREFIX}/${PORTNAME} -type f | \
	    ${XARGS} ${CHMOD} -wx
	${FIND} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin \
	    ${STAGEDIR}${PREFIX}/${PORTNAME}/libexec/gcc/${PORTNAME}/5.2.0 \
	    ${STAGEDIR}${PREFIX}/${PORTNAME}/${PORTNAME}/bin -type f | \
	    ${XARGS} ${CHMOD} +x

.include <bsd.port.mk>
