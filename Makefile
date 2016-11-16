all: build

DEB_MAJOR_VERSION := 1.0${DEB_VERSION_QUALIFIER}
DEB_COMPONENT := clearwater-sip-stress
DEB_NAMES := clearwater-sip-stress

build:
	cd ./sipp && autoreconf -vifs && ./configure && make

clean:
	${MAKE} -C ./sipp clean

include build-infra/cw-deb.mk

.PHONY: deb
deb: build deb-only

.PHONY: all build test clean distclean
