#! /usr/bin/env bash

# configure variables in the section below
GHDL_BACKEND="llvm"
GHDL_VERSION="0.34dev"
RELEASE_DATE="2016-09-14"

GITHUB_SERVER="https://github.com"
GITHUB_SLUG="tgingold/ghdl"
GITHUB_URL="$GITHUB_SERVER/$GITHUB_SLUG.git"

TEMP_DIR="temp"
GHDL_DIR="ghdl"
BUILD_DIR="build"

# other variables
# --------------------------------------
GITROOT=$(pwd)

GHDL_REPO_DIR="$GITROOT/$TEMP_DIR/$GHDL_DIR"
GHDL_BUILD_DIR="$GITROOT/$TEMP_DIR/$GHDL_DIR/$BUILD_DIR"
GHDL_INSTALL_DIR="$GITROOT/$GHDL_DIR"

# define color escape codes
RED='\e[0;31m'			# Red
GREEN='\e[1;32m'		# Green
YELLOW='\e[1;33m'		# Yellow
MAGENTA='\e[1;35m'	# Magenta
CYAN='\e[1;36m'			# Cyan
NOCOLOR='\e[0m'			# No Color


echo -e "${MAGENTA}========================================${NOCOLOR}"
echo -e "${MAGENTA} Cloning, compiling and installing GHDL ${NOCOLOR}"
echo -e "${MAGENTA}========================================${NOCOLOR}"
echo -e "${CYAN}mkdir -p $TEMP_DIR${NOCOLOR}"
mkdir -p $TEMP_DIR
cd $TEMP_DIR

# downloading GHDL
echo -e "${CYAN}Cloneing GHDL from $GITHUB_URL...${NOCOLOR}"
git clone $GITHUB_URL $GHDL_DIR
if [ $? -eq 0 ]; then
	echo -e "${GREEN}Cloneing [SUCCESSFUL]${NOCOLOR}"
else
	echo 1>&2 -e "${RED}Cloneing from '$GITHUB_URL' [FAILED]${NOCOLOR}"
	exit 1
fi

cd $GHDL_REPO_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

../configure --prefix=$GHDL_INSTALL_DIR --with-llvm-config=llvm-config-4.0
if [ $? -eq 0 ]; then
	echo -e "${GREEN}Configuring GHDL for LLVM-4.0 [SUCCESSFUL]${NOCOLOR}"
else
	echo 1>&2 -e "${RED}Configuring GHDL for LLVM-4.0 [FAILED]${NOCOLOR}"
	exit 1
fi

gcc -v
gnat -v
clang -v
clang++ -v

make
if [ $? -eq 0 ]; then
	echo -e "${GREEN}Building GHDL for LLVM-4.0 [SUCCESSFUL]${NOCOLOR}"
else
	echo 1>&2 -e "${RED}Building GHDL for LLVM-4.0 [FAILED]${NOCOLOR}"
	exit 1
fi

make install
if [ $? -eq 0 ]; then
	echo -e "${GREEN}Installing GHDL SUCCESSFUL]${NOCOLOR}"
else
	echo 1>&2 -e "${RED}Installing GHDL [FAILED]${NOCOLOR}"
	exit 1
fi

cd $GHDL_INSTALL_DIR

# test ghdl version
echo -e "${CYAN}Testing GHDL version...${NOCOLOR}"
./bin/ghdl -v
if [ $? -eq 0 ]; then
	echo -e "${GREEN}GHDL test [SUCCESSFUL]${NOCOLOR}"
else
	echo 1>&2 -e "${RED}GHDL test [FAILED]${NOCOLOR}"
	exit 1
fi
