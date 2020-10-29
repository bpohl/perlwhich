# perlwhich.pl
**List the location and version of one or more installed [`Perl`](https://www.perl.org/) packages, or let you know which aren't installed.**

I thought I was being original but is seems there are other people with utilities along this same line.  This one is mine and has its roots a couple of decades ago.  This is just the first version I'm putting out for others to use.

## Installation

Just copy the script to someplace in your PATH.  I actually have the script someplace off the PATH with a symbolic link to it in the path with the '.pl' removed from the name so as to make tab-completion look good with only one resolution.

## Usage

    perlwhich.pl [--[no]color] Package::Name ...

Specifying `--color` forces ANSI Color on where as `--nocolor` forces it off.  If not specified, color will be used if output is to a terminal. 

## Version

<!-- $Id: f370f71901c280be27223453b5f51f6dbbeca8fd$ -->

$Revision: Wed Oct 28 19:49:07 2020 -0500 on branch main$<br>$Tags: v1.0.0$

## Copyright

&copy; 2020 Bion Pohl/Omega Pudding Software Some Rights Reserved

$Author:$<br>$Email:$
