all: build

DEB_MAJOR_VERSION := 1.0${DEB_VERSION_QUALIFIER}
DEB_COMPONENT := clearwater-perf-utils
DEB_NAMES := clearwater-sip-stress-coreonly

build:
	cd ./sipp && autoreconf -vifs && ./configure && make && mv sipp sipp_coreonly

clean:
	${MAKE} -C ./sipp clean
	rm ./sipp/sipp_coreonly

include build-infra/cw-deb.mk

.PHONY: deb
deb: build deb-only

.PHONY: all build test clean distclean
