ecasound -a 1,2 -i test.mp3 -a:1 -o alsa -a:2 -o stdout | ocaml unix.cma scopes.cma pipein.ml
