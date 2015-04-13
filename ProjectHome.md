**Camleon** is an OCaml+OpenGL-based library for programming real-time **music visualizations** (i.e. 'eye-candy').

Camleon is currently in the **very (very!) early stages of development**, but the goal is to provide a platform allowing programmers to easily create OpenGL-based visualizations of real-time sound/music input, not unlike the C library 'libvisual'.

#### Roadmap ####
Here's a rough sketch of how this project will (hopefully) proceed. The goal is to provide the following (in more or less this order):

  1. ~~Figure out how to use fftw and OpenGL with OCaml~~ -- _done!_
  1. Build a basic OCaml library for analyzing the spectral content (i.e. the frequencies) of streaming sound -- _almost done_
  1. Implement basic proof-of-concept spectrograph visualizations in ASCII -- _almost done_
  1. Implement basic spectrograph visualization in OpenGL based on above library
  1. Build a higher-order analysis library for extracting harmonics, beat detection, timbre, etc.
  1. Implement some visualizations based on this high-order analysis
  1. Look into releasing these visualization as plugins for Winamp, iTunes, Amarok, etc.
  1. Publish an API, evangelize the library as a tool for the visualization community


#### Why OCaml? ####
Camleon is written in OCaml, a fast and elegant language (fast in the sense that compiled code is only slightly slower than C), and provides a good, hardware-agnostic interface for dealing with OpenGL (via mesa/glut). Because OCaml abstracts away the hardware level with minimal cost to performance, it is an ideal language for visualization, allowing programmers to focus on creating interesting visuals rather than dealing with implementational issues.