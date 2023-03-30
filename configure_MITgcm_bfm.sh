#! /bin/bash

usage() {
echo "   Generates two output directories:"
echo "   MYCODE/"
echo "   READY_FOR_MODEL_NAMELISTS/"
echo ""
echo "   SYNOPSYS"
echo "   configure_MITgcm_bfm.sh [ --preset PRESET] "

echo "   PRESET can be NORTH_ADRIATIC or CUBE-GMD"
echo ""
}


if [ $# -lt 2 ] ; then
  usage
  exit 1
fi

for I in 1 ; do
   case $1 in
      "--preset" ) PRESET=$2;;
        *  ) echo "Unrecognized option $1." ; usage;  exit 1;;
   esac
   shift 2
done


  
     BFMDIR=$PWD/bfm
 COUPLERDIR=$PWD/bfm/src/mitgcm
MITGCM_ROOT=$PWD/MITgcm
     MYCODE=$PWD/MYCODE
  NAMELISTS=$PWD/READY_FOR_MODEL_NAMELISTS


mkdir -p $MYCODE $NAMELISTS
#########  copying from MITgcm original code ############

[[ -f $MYCODE/SIZE.h             ]] ||  cp MITgcm/model/inc/SIZE.h $MYCODE
[[ -f $MYCODE/CPP_OPTIONS.h      ]] ||  cp MITgcm/model/inc/CPP_OPTIONS.h $MYCODE
[[ -f $MYCODE/OBCS_OPTIONS.h     ]] ||  cp MITgcm/pkg/obcs/OBCS_OPTIONS.h $MYCODE 
[[ -f $MYCODE/RBCS_SIZE.h        ]] ||  cp MITgcm/pkg/rbcs/RBCS_SIZE.h $MYCODE 
[[ -f $MYCODE/EXF_OPTIONS.h      ]] ||  cp MITgcm/pkg/exf/EXF_OPTIONS.h $MYCODE 
[[ -f $MYCODE/GCHEM.h            ]] ||  cp MITgcm/pkg/gchem/GCHEM.h $MYCODE 
[[ -f $MYCODE/GCHEM_OPTIONS.h    ]] ||  cp MITgcm/pkg/gchem/GCHEM_OPTIONS.h $MYCODE 
[[ -f $MYCODE/PTRACERS_SIZE.h    ]] ||  cp MITgcm/pkg/ptracers/PTRACERS_SIZE.h $MYCODE
[[ -f $MYCODE/DIAGNOSTICS_SIZE.h ]] ||  cp MITgcm/pkg/diagnostics/DIAGNOSTICS_SIZE.h $MYCODE

########  copying from preset #############
cp $PWD/presets/${PRESET}/*.h $MYCODE
cp $PWD/presets/${PRESET}/*.F $MYCODE

echo "Now edit and configure your setup in $MYCODE/"

cp $COUPLERDIR/BFMcoupler*.F $MYCODE
cp $COUPLERDIR/BFMcoupler*.h $MYCODE

cd $COUPLERDIR
python2 passivetrc_reducer_8chars.py -i $BFMDIR/build/tmp/OGS_PELAGIC/namelist.passivetrc -o $NAMELISTS/namelist.passivetrc

python2 bfm_config_gen.py -i $NAMELISTS/namelist.passivetrc --type code     -o $MYCODE
python2 bfm_config_gen.py -i $NAMELISTS/namelist.passivetrc --type namelist -o $NAMELISTS

python2 diff_apply.py -i $MITGCM_ROOT  -o $MYCODE
