#!/bin/sh

aptitude search '~i!~M' | perl -ne '/^i\s+(\S+)\s/; print "$1\n"'
