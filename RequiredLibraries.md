In addition to the standard OCaml distribution, camleon needs:

  1. OCaml bindings for the fftw library: http://math.umh.ac.be/an/software.php
  1. OCaml OpenGL bindings (LablGL): http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html

You will also need **findlib** to make installing the above libraries easier (it provides **ocamlfind**, which installation scripts use). The findlib package is a bit hard to track down, but you can try here: http://funlinks.camlcity.org/frames.html

# FFTW #

The OCaml bindings for fftw -- the fast fourier transform library -- currently work with fftw version 2. A version of the bindings for fftw3 is in development, but camleon currently works with the old version 2.

You'll need the fftw headers package for your distro (probably fftw-dev or fftw-devel) to compile the ocaml fftw bindings.

### SUSE notes (these might apply to Red Hat-based distros too) ###

In the ocaml fftw **Makefile**, make the following changes:

`OCAMLH=$(shell ocamlc -where)/caml` **===>** `OCAMLH=$(shell ocamlc -where)`

`INCLUDE_FFTW = /usr/include/fftw` **===>**  `INCLUDE_FFTW = /usr/include/`

all occurances of `-lfftw` **===>** `-ldfftw`

all occurances of `-lrfftw` **===>** `-ldrfftw`

Also, after compiling and installing, if you want to run `make test` to ensure that the fftw stuff was installed correctly and you have a 32-bit system, you _may_ have to make the following change in **test.ml**:

all occurrances of `float64` **===>** `float32`

To run the `test.ml` file, you'll probably have to compile a toplevel executable like so:

```
ocamlmktop -I /usr/lib/ocaml/fftw2 fftw2.cma -o ocaml-fftw
```

Then run:

```
chmod +x ocaml-fftw
./ocaml-fftw -I /usr/lib/ocaml/fftw2 test.ml
```

# LablGL #

  1. Make sure you have the mesa libraries and headers installed for your distro (for example, **Mesa** and **Mesa-devel** on SuSE)
  1. Download the latest **LablGL** library (i.e. lablgl-1.02.tar.gz), untar it, and cd into the untarred directory.
  1. On Linux, copy **Makefile.config.linux.mdk** to **Makefile.config**. See the LablGL **README** for other platforms as well as detailed config instructions. Make sure you have glut/Mesa installed along with the devel headers package for your distro.
  1. `make glut`
  1. `sudo make install`

To test that everything went well, try running **lablglut** (it should be in /usr/bin or /usr/local/bin). Running this should put you in an interactive OCaml prompt.