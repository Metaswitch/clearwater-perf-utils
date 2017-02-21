all: build

DEB_MAJOR_VERSION := 1.0${DEB_VERSION_QUALIFIER}
DEB_COMPONENT := clearwater-perf-utils
DEB_NAMES := clearwater-sip-stress-coreonly

build:
	cd ./sipp && autoreconf -vifs && LDFLAGS="-static-libgcc -static-libstdc++" ./configure && make && mv sipp sipp_coreonly

clean:
	${MAKE} -C ./sipp clean
	rm ./sipp/sipp_coreonly

include build-infra/cw-deb.mk

.PHONY: deb
deb: build deb-only

libraries/libtinfo.so.5:
	cp /lib/x86_64-linux-gnu/libtinfo.so.5 $@

libraries/ld-linux-x86-64.so.2:
	cp /lib64/ld-linux-x86-64.so.2 $@

.PHONY: docker
docker: libraries/libtinfo.so.5 libraries/ld-linux-x86-64.so.2 build
	 docker build -t clearwater-stresstool .

.PHONY: all build test clean distclean
