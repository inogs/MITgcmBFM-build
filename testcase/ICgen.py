import argparse


def argument():
    parser = argparse.ArgumentParser(description = '''Creates ready IC files for MITgcm 
                               both physical and biogeochemical. Since input data come from other external run,
                               a linear interpolation is performed. 
                               If argument MODELVARLIST is given with biogeochemical variable list, IC for these BIO variables
                               will be created. Else, physical IC will be created.
                               
                               ''')
    parser.add_argument(   '--outdir', '-o',
                            type = str,
                            required = True,
                            help ='/some/path/'
                            )
    return parser.parse_args()    

import os, glob
import numpy as np
args = argument()


filelist=glob.glob('input/init/init.???')
OUTDIR=args.outdir

jpk=30
M2d = np.ones((64,64),np.float32)

for filename in filelist:
    var=os.path.basename(filename)[-3:]
    profile= np.loadtxt(filename)
    outBinaryFile = "%sIC_%s.dat" %(OUTDIR,var)
    print(outBinaryFile)
    F = open(outBinaryFile,'wb')
    for jk in range(30) : F.write(M2d*profile[jk])
    F.close()
    
    