# Makefile copied from ocaml fftw... (hence the inexplicable vestiges)


PKGNAME=camleon
PKGVERSION=0.1

CC=gcc
CC_FLAGS = -fPIC
## Caml C header files location:
OCAMLH=$(shell ocamlc -where)/caml
## Caml binaries:
OCAMLC	  = ocamlc
OCAMLOPT  = ocamlopt
OCAMLDEP  = ocamldep
OCAMLDOC  = ocamldoc
OCAMLFIND = ocamlfind
OCAMLC_FLAGS   = -g -dtypes bigarray.cma -I /usr/lib/ocaml
OCAMLOPT_FLAGS = -dtypes

#DISTFILES = INSTALL LICENSE META.in Makefile \
#  fftw64.ml fftw64.mli fftw-float-type.c fftw2_stub.c \
#  test.ml

PKG_TARBALL = $(PKGNAME)-$(PKGVERSION).tar.gz


scopes.cma: 
	$(OCAMLC) -a scopes.ml -o $@ $(OCAMLC_FLAGS)

ETA: META.in
	echo "version = \"$(PKGVERSION)\"" > $@
	cat $^ >> $@

