#! /bin/bash

RUNDIR=$PWD/wrkdir/run
INPUTDIR=$PWD/wrkdir/input/binaries

rm -rf   $RUNDIR $INPUTDIR
mkdir -p $RUNDIR $INPUTDIR


for I in input/*gz ; do
   filename=$( basename $I )
   gzip -dc $I > ${INPUTDIR}/${filename%.gz}
done 

python ICgen.py -o ${INPUTDIR}

cp  ../bfm/build/tmp/OGS_PELAGIC/*nml $RUNDIR
cp namelists/* $RUNDIR

cp ../MITGCM_BUILD/mitgcmuv $RUNDIR

