#! /bin/bash


mkdir -p wrkdir/run
mkdir -p wrkdir/input/binaries

for I in input/*gz ; do
   filename = $( basename $I )  
   gzip -dc $I > wrkdir/input/binaries/${filename%.gz}
done 

python IC_gen.py -o wrkdir/input/binaries

