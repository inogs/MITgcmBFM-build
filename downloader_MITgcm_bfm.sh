#! /bin/bash


  BFM_BRANCH=dev_ogs

 MITGCM_TAG=checkpoint66j

# ----------- BFM library ---------------------

OGSTM_HOME=$PWD

# Requirement: to have an account on git server
git clone git@github.com:CMCC-Foundation/BiogeochemicalFluxModel.git bfm
cd bfm
git checkout -b $BFM_BRANCH origin/$BFM_BRANCH
git checkout a59f79ba30edf90229fbf76ddf2a077

cd $OGSTM_HOME
git clone git@github.com:gcossarini/BFMCOUPLER.git
cd BFMCOUPLER
git checkout bfmv5

cd $OGSTM_HOME
git clone https://github.com/MITgcm/MITgcm.git
cd MITgcm
git checkout -b $MITGCM_TAG $MITGCM_TAG
