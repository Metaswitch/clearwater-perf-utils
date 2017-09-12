all: build

ROOT ?= ${PWD}

DEB_MAJOR_VERSION := 1.0${DEB_VERSION_QUALIFIER}
DEB_COMPONENT := clearwater-perf-utils
DEB_NAMES := clearwater-sip-stress-coreonly

build: sipp/sipp_coreonly

sipp/configure: sipp/configure.ac
	cd ./sipp && autoreconf -vifs

sipp/Makefile: sipp/configure
	cd ./sipp && ./configure

sipp/sipp_coreonly: sipp/Makefile $(shell find sipp -type f)
	cd ./sipp && make && mv sipp sipp_coreonly

sipp/sipp_static: sipp/Makefile $(shell find sipp -type f)
	cd ./sipp && make sipp_static

clean:
	${MAKE} -C ./sipp clean
	rm ./sipp/sipp_coreonly

include build-infra/cw-deb.mk

.PHONY: deb
deb: build deb-only

.PHONY: docker
docker:
	 docker build -t clearwater-stresstool .

.PHONY: all build test clean distclean
