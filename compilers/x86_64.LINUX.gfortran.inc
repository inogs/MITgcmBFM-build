#!/bin/bash

# $Header: /u/gcmpack/MITgcm/tools/build_options/linux_amd64_gfortran,v 1.22 2013/09/23 23:32:59 jmc Exp $
# $Name: checkpoint64q $

# Build options for gfortran compiler (GNU) on Linux AMD64 platform
#
#  Tested with gcc-gfortran v4.1.x as shipped with Fedora Core 6,7,8
#         with gcc-gfortran v4.3.x as shipped with Fedora Core 9,10
#
# OpenMP : Tested on dickens with gcc-gfortran v4.3.2 as shipped with FC 10
#              on baudelaire with gcc-gfortran v4.4.5 as shipped with FC 13
#              on danton     with gcc-gfortran v4.5.1 as shipped with FC 14
#                            with gcc-gfortran v4.7.x as shipped with FC 17
#                            with gcc-gfortran v4.8.1 as shipped with FC 19
#              on acesgrid   with gcc-gfortran v4.6.0 as shipped with FC 15
#
# MPI : Tested on acesgrid (Fedora Core 15), using:
#       module load gcc     (Version 4.6.0)
#   and with mpich1:
#       module load mvapich
#   or  with mpich2:
#       module load mvapich2
#   or  with openmpi:
#       module load openmpi
# and on baudelaire.csail.mit.edu (FC13), using:
	export MPI_GCC_DIR=/usr/lib64/openmpi
	export MPI_INC_DIR=/usr/include/openmpi-x86_64
	export PATH=$MPI_GCC_DIR/bin:$PATH

#-------
# run with OpenMP: needs to set environment var. OMP_NUM_THREADS
#    and generally, needs to increase the thread stack-size:
#   -  sh,bash:
#     > export OMP_NUM_THREADS=2
#     > export GOMP_STACKSIZE=400m
#   - csh,tcsh:
#     > setenv OMP_NUM_THREADS 2
#     > setenv GOMP_STACKSIZE 400m
#-------

if test "x$MPI" = xtrue ; then
  CC=${CC:=mpicc}
  FC=${FC:=mpif90} # formerly f77
  F90C=${F90C:=mpif90}
else
  CC=gcc
  FC=gfortran
  F90C=gfortran
fi

DEFINES='-DWORDLENGTH=4 -DNML_TERMINATOR="/"'
EXTENDED_SRC_FLAG='-ffixed-line-length-132'
F90FIXEDFORMAT='-ffixed-form'
GET_FC_VERSION="--version"
OMPFLAG='-fopenmp'

NOOPTFLAGS='-O0'
NOOPTFILES=''

CFLAGS='-O0'
#- Requires gfortran from 2006 onwards for -fconvert=big-endian
# FFLAGS="$FFLAGS -fimplicit-none"
FFLAGS="$FFLAGS -fimplicit-none -ffixed-line-length-132"
#- for big setups, compile & link with "-fPIC" or set memory-model to "medium":
# CFLAGS="$CFLAGS -fPIC"
# FFLAGS="$FFLAGS -fPIC"
#- with FC 19, need to use this without -fPIC (which cancels -mcmodel option):
CFLAGS="$CFLAGS -mcmodel=medium"
FFLAGS="$FFLAGS -mcmodel=medium"

if test "x$IEEE" = x ; then     #- with optimisation:
   #- full optimisation
    FOPTIM='-O3 -funroll-loops'
    NOOPTFILES="$NOOPTFILES ini_masks_etc.F"
   #- can use -O2 (safe optimisation) to avoid Pb with some gcc version of -O3:
   # FOPTIM='-O2 -funroll-loops'
else
   # these may also be useful, but require specific gfortran versions:
   # -Wnonstd-intrinsics  for gfortran <= 4.3
   # -Wintrinsics-std     for gfortran >= 4.4
   # -Wno-tabs            for gfortran >= 4.3
    FFLAGS="$FFLAGS -Waliasing -Wampersand -Wsurprising -Wline-truncation"
   #- to get plenty of warnings: -Wall -Wextra (older form: -Wall -W) or:
   # FFLAGS="$FFLAGS -Wconversion -Wimplicit-interface -Wunused-labels"
  if test "x$DEVEL" = x ; then  #- no optimisation + IEEE :
    FOPTIM='-O0'
  else                          #- development/check options:
    FOPTIM='-O0 -g -fbounds-check'
    FOPTIM="$FOPTIM -ffpe-trap=invalid,zero,overflow -finit-real=inf"
  fi
fi

F90FLAGS=$FFLAGS
F90OPTIM=$FOPTIM

export NETCDF_INC=/usr/lib64/gfortran/modules/
export NETCDF_LIB=/usr/lib64

NETCDF_ROOT='/usr'
NETCDF_HOME='/usr'
INCLUDEDIRS='/usr/include'
INCLUDES='-I/usr/include -I/usr/include/gsl -I/usr/include/openblas'
LIBS='-L/usr/lib64 -L/usr/lib -L/usr/lib64/atlas'
GSL_INC='/usr/include/gsl'
GSL_LIB='/usr/lib64 -lgsl -lgslcblas'

if [ -n "$MPI_INC_DIR" -a "x$MPI" = xtrue ] ; then
    INCLUDEDIRS="$INCLUDEDIRS $MPI_INC_DIR"
    INCLUDES="$INCLUDES -I$MPI_INC_DIR"
    #- used for parallel (MPI) DIVA
    MPIINCLUDEDIR="$MPI_INC_DIR"
    # MPI_HEADER_FILES='mpif. mpiof.h netcdf.inc'
fi

export INCLUDEDIRS="$INCLUDEDIRS $BFM_INC $GSL_INC"
export INCLUDES="$INCLUDES -I$BFM_INC -I$GSL_INC"
export LIBS="$LIBS -L$BFM_LIB -lbfm -L$GSL_LIB -L$NETCDF_LIB -lnetcdf"

echo $NETCDF_LIB
