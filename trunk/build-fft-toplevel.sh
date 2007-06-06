#!/bin/bash

# Builds toplevel binary with fftw built-in.
# Note that you'll still need to include the fft2 directory when you run ocaml-fftw; i.e.:
#
#   ocaml-fftw -I /usr/lib/ocaml/fftw2 foo.ml

ocamlmktop -o ocaml-fftw -I /usr/lib/ocaml/fftw2 -I /usr/lib/ocaml bigarray.cma fftw2.cma
