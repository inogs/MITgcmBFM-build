#! /bin/bash

usage() {
echo "Launches MITgcm_build after bfm lib compiling"
echo "HYPOTHESYS: there is an only SIZE.h file for each preset"
echo "SYNOPSYS"
echo "main_builder.sh -p [preset] "
echo ""
echo "EXAMPLES"
echo "main_builder.sh -p tyr"
}

if [ $# -lt 2 ] ; then
  usage
  exit 1
fi

for I in 1 ; do
    case $1 in
        -p ) preset=$2
            ;;
        *) echo "Unexpected option: $1"; usage; exit 1 ;;
    esac
    shift 2
done



set -e
rm -rf MYCODE

PRESET=${preset^^}
./configure_MITgcm_bfm.sh -p $PRESET
UNIQUE_SIZE_FILE=$(ls presets/${PRESET}/)
cp -v presets/${PRESET}/${UNIQUE_SIZE_FILE} MYCODE/SIZE.h
./builder_MITgcm_bfm.sh -o MITgcm
cp -v MITGCM_BUILD/mitgcmuv mitgcmuv_${preset}

