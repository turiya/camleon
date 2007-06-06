#!/bin/bash

# Convenience script for running in the opengl-enabled environment.

lablglut -I +lablGL -I +threads unix.cma threads.cma $1
