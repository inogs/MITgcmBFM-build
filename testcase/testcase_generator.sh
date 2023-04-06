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

ln -fs $HERE/../READY_FOR_MODEL_NAMELISTS/data.ptracers
ln -fs $HERE/../READY_FOR_MODEL_NAMELISTS/data.diagnostics

ln -fs $HERE/../MITGCM_BUILD/mitgcmuv

