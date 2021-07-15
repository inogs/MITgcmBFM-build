# MITgcmBFM-build



#! /bin/bash

CODE_DIR=/path/to/local/code
git clone git@github.com:inogs/MITgcmBFM-build.git $CODE_DIR
cd $CODE_DIR

# choose your branch
git checkout main 

./downloader_MITgcm_bfm.sh

# edit builder_MITgcm_bfm.sh - to set debug or not, compiler, ecc

./builder_MITgcm_bfm.sh -o bfm

./configure_MITgcm_bfm.sh
./builder_MITgcm_bfm.sh -o MITgcm
