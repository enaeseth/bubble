Bubble
======

Bubble creates a friendly userland for you to live in when forced to use an
older *nix box, such as older versions of RHEL.

    $ cat /etc/redhat-release
    Red Hat Enterprise Linux Server release 5.8 (Tikanga)

    $ zsh --version
    zsh 5.0.0 (x86_64-unknown-linux-gnu)

    $ vim --version
    VIM - Vi IMproved 7.3 (2010 Aug 15, compiled Nov 20 2012 23:09:46)
    Compiled by Bubble
    Huge version without GUI.

Installation
------------

Bubble should install on most *nix machines that have a working build toolchain
and [wget(1)](http://www.gnu.org/software/wget/). In particular, it is known
to install on RHEL 5.8, and Mac OS X 10.7 (with external wget installed).

Clone this repository or extract a tarball in your home directory. This example
will assume you call the folder that contains this readme "bubble", but you can
use any name you like.

Once the directory is present:

    $ cd ~/bubble && make all

This will download, compile, and install the utilities that Bubble provides, and
their dependencies.

To make tools provided by Bubble available, you'll need to add its *bin* folder
to your `$PATH`.

### zsh

Add the following to your *.zshenv* file, or create it if it does not exist:

    [ -d "$HOME/bubble/bin" ] && export PATH="$HOME/bubble/bin:$PATH"

### bash

Add the following to your *.bashrc* file:

    [ -d "$HOME/bubble/bin" ] && export PATH="$HOME/bubble/bin:$PATH"

What's in the box?
------------------

- GNU coreutils 8.20
- Vim 7.3
- zsh 5.0.0
- Git 1.8.0
- GNU tar 1.26 (with bz2, gz, and xz support)
