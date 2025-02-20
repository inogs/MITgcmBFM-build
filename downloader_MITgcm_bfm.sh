#! /bin/bash


  BFM_BRANCH=dev_ogs

 MITGCM_TAG=checkpoint68z

# ----------- BFM library ---------------------

OGSTM_HOME=$PWD

# Requirement: to have an account on git server
git clone git@github.com:CMCC-Foundation/BiogeochemicalFluxModel.git bfm
cd bfm
git checkout -b $BFM_BRANCH origin/$BFM_BRANCH

cd $OGSTM_HOME
git clone git@github.com:inogs/MITgcmBFM_coupler.git BFMCOUPLER
cd BFMCOUPLER
git checkout moving_to_checkpoint_68z

cd $OGSTM_HOME
git clone https://github.com/MITgcm/MITgcm.git
cd MITgcm
git checkout -b $MITGCM_TAG $MITGCM_TAG
