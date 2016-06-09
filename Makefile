# -*- Mode: Makefile -*-
#
# Created Thu Jun  9 15:13:35 AKDT 2016
# by Raymond E. Marcil <marcilr@gmail.com>
# Copyright (C) 2016 Raymond E. Marcil
# 
# Permission is granted to copy, distribute and/or modify this document
# under the terms of the GNU Free Documentation License, Version 1.3
# or any later version published by the Free Software Foundation;
# with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
# A copy of the license is included in the section entitled "GNU
# Free Documentation License".
#
# Makefile for svn to git conversion
#
# Links
# =====
# Makefile Conventions
# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_14.html
#

#
# Binaries
#
CAT    = cat
CP     = cp
CUT    = cut
FIND   = find
GREP   = grep
MKDIR  = mkdir
PS2PDF = ps2pdf
RM     = rm -rf
RSYNC=/usr/bin/rsync -va --progress --stats --exclude ".svn" --exclude "*~" --exclude "*bak"
SED    = sed
TAR    = tar
TR     = tr


# DIST directory
DIST   = dist

# Set VERSION file to use.
VERSIONFILE = "VERSION"

#
# Extract major,minor, and debug numbers from VERSION file.
# 1. Look at VERSION file with cat.
# 2. Extract "major =" line with grep.
# 3. Get 2nd field with major using cut.
# 4. Strip spaces with tr.
#
MAJOR = `${CAT} ${VERSIONFILE} | ${GREP} major | ${CUT} -f 2 -d '=' | ${TR} -d " "`
MINOR = `${CAT} ${VERSIONFILE} | ${GREP} minor | ${CUT} -f 2 -d '=' | ${TR} -d " "`
PATCH = `${CAT} ${VERSIONFILE} | ${GREP} patch | ${CUT} -f 2 -d '=' | ${TR} -d " "`

# Build VERSION number from MAJOR, MINOR, and PATCH
# The use of shell resolves the cat, grep, cut, and tr commands
# before executing targets.
VERSION = $(shell echo ${MAJOR}.${MINOR}.${PATCH})

# Present working directory in BASE variable
BASE = $(shell pwd)

# Hardcode BASENAME
BASENAME=dist
#BASENAME = $(shell ls *.tex.in | ${SED} 's/.tex.in//g')
#BASENAME = $(shell ls *.tex | ${SED} 's/.tex//g')

# Distribution tarball
BZ2 = ${BASENAME}-${VERSION}.tar.bz2

# Define phony. i.e. non-file targets.
.PHONY: all clean mostlyclean cycle dist

# Run clean, no build target yet.
all:
	@echo "Nothing to do..."

#
# Build source distribution.
# cp doesn't have an exclude option.  Didn't want to use rsync.
# Better way to copy and exclude? Perhaps use of 'grep -v'? 
#
dist: mostlyclean ${DIST} 


#
# Copy all files to versioned project directory.
# A trailing slash on the rsync source path tells rsync copy the files
# from that directory into the target directory.  If there is no trailing
# slash, the directory itself will be copied and created if necessary.
#
${BASENAME}-${VERSION}:
	echo "BASE: ${BASE}"
	${RSYNC} ${BASE}/ ${BASENAME}-${VERSION}


#
# Create distribution directory to tar.  Using rsync since 
# couldn't get cp with exclude to work in Makefile.
#
${DIST}: clean ${BASENAME}-${VERSION}
	${TAR} -cvjpf ${BZ2} ${BASENAME}-${VERSION}
	${RM} ${BASENAME}-${VERSION}


clean:
	${RM} ${BASENAME}-${VERSION}
	${RM} ${BZ2} *.tmp *~

cycle: clean 
