all: build

ROOT ?= ${PWD}
MK_DIR := ${ROOT}/mk
PREFIX ?= ${ROOT}/usr
INSTALL_DIR ?= ${PREFIX}
MODULE_DIR := ${ROOT}/modules

DEB_MAJOR_VERSION := 1.0${DEB_VERSION_QUALIFIER}
DEB_COMPONENT := clearwater-sip-stress
DEB_NAMES := clearwater-sip-stress

INCLUDE_DIR := ${INSTALL_DIR}/include
LIB_DIR := ${INSTALL_DIR}/lib

SUBMODULES := sipp

include build-infra/cw-module-install.mk

SIPP_DIR := sipp

sipp:
	cd ${SIPP_DIR} && autoreconf -vifs && ./configure && make

sipp_test:
	true

sipp_clean:
	${MAKE} -C ${SIPP_DIR} clean

sipp_distclean: sipp_clean

.PHONY: sipp sipp_test sipp_clean sipp_distclean

.PHONY: update_submodules
update_submodules: ${SUBMODULES} sync_install

build: update_submodules

test: update_submodules

full_test: update_submodules

testall: $(patsubst %, %_test, ${SUBMODULES}) full_test

clean: $(patsubst %, %_clean, ${SUBMODULES})
	rm -rf ${ROOT}/usr
	rm -rf ${ROOT}/build

distclean: $(patsubst %, %_distclean, ${SUBMODULES})
	rm -rf ${ROOT}/usr
	rm -rf ${ROOT}/build

include build-infra/cw-deb.mk

.PHONY: deb
deb: build deb-only

.PHONY: all build test clean distclean
