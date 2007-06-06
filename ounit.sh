#!/bin/bash

# Convenience script for running oUnit tests.

./ocaml-fftw unix.cma oUnit.cma -I +oUnit -I +fftw2 $1
