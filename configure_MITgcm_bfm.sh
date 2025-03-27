#! /bin/bash

usage() {
echo "Generates two output directories:"
echo "- MYCODE"
echo "- READY_FOR_MODEL_NAMELISTS"
echo ""
echo "SYNOPSYS"
echo "configure_MITgcm_bfm.sh [ -p PRESET] "
echo "PRESET can be NORTH_ADRIATIC or NAD_MER"
echo ""
echo "EXAMPLE"
echo "./configure_MITgcm_bfm.sh -p NAD_MER"
}


if [ $# -lt 2 ] ; then
  usage
  exit 1
fi

for I in 1 ; do
   case $1 in
      "-p" ) PRESET=$2;;
        *  ) echo "Unrecognized option $1." ; usage;  exit 1;;
   esac
   shift 2
done

set -e
  
 COUPLERDIR=$PWD/BFMCOUPLER
     BFMDIR=$PWD/bfm
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
[ -f $PWD/presets/${PRESET}/*.h ] && cp -v $PWD/presets/${PRESET}/*.h $MYCODE
[ -f $PWD/presets/${PRESET}/*.F ] && cp -v $PWD/presets/${PRESET}/*.F $MYCODE


cp $COUPLERDIR/BFMcoupler*.F $MYCODE
cp $COUPLERDIR/BFMcoupler*.h $MYCODE

cd $COUPLERDIR
python passivetrc_reducer_8chars.py -i $BFMDIR/build/tmp/OGS_PELAGIC/namelist.passivetrc -o $NAMELISTS/namelist.passivetrc

python bfm_config_gen.py -i $NAMELISTS/namelist.passivetrc --type code     -o $MYCODE
python bfm_config_gen.py -i $NAMELISTS/namelist.passivetrc --type namelist -o $NAMELISTS

python diff_apply.py -i $MITGCM_ROOT  -o $MYCODE -n 12
echo "Now you can manually edit and configure your setup in $MYCODE/"
echo "IMPORTANT: copy your specific SIZE.h_{number_of_points} from presets/${PRESET} in MYCODE/SIZE.h"

