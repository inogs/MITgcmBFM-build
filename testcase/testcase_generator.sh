#! /bin/bash

RUNDIR=$PWD/wrkdir/run
INPUTDIR=$PWD/wrkdir/input/binaries/

rm -rf   $RUNDIR $INPUTDIR
mkdir -p $RUNDIR $INPUTDIR/ICs/BIO


for I in input/*gz ; do
   filename=$( basename $I )
   gzip -dc $I > ${INPUTDIR}/${filename%.gz}
done 

python ICgen.py -o ${INPUTDIR}/ICs/BIO/

cp  ../bfm/build/tmp/OGS_PELAGIC/*nml $RUNDIR

HERE=$PWD
cd $RUNDIR
for I in $HERE/namelists/* ; do
	ln -s $I
done
cd $HERE
#cp namelists/* $RUNDIR

cp ../MITGCM_BUILD/mitgcmuv $RUNDIR

