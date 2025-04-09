# MITgcmBFM-build


```bash
#! /bin/bash

CODE_DIR=/path/to/local/code
git clone git@github.com:inogs/MITgcmBFM-build.git $CODE_DIR
cd $CODE_DIR
```

# choose your branch
```bash
git checkout main 
./downloader_MITgcm_bfm.sh
```

# edit builder_MITgcm_bfm.sh - to set debug or not, compiler, ecc
```bash
./builder_MITgcm_bfm.sh -o bfm
```

```bash
./configure_MITgcm_bfm.sh
```

```bash
./builder_MITgcm_bfm.sh -o MITgcm
```
