# MIN-WRAPP
A minimalistic ubuntu 20.04 Docker based project to use as a shell wrapper for your projects

## PREREQUISITES
Bash, make, docker. 

## USAGE
Check the usage
```bash
make
```
, which is the same as
```bash
make help
```

## INSTALL
Build the ubuntu 20.04 image, init the container and show the help from the deploy script
```bash
make install_devops
```

## RUN 
Run an example function ... 
```bash
make run
```

## SPAWN !!!
To spawn this thingy into YOUR thingy do:
```bash
TGT_PROJ=thingy make spawn_tgt_project
```

## NAMING CONVENTOINS
Any function should have a `*.func.sh` file path naming convention. The function name should be 
the same as the file name, but having the `do_` suffix and snake case

Place all the funcs here: 
```bash
src/bash/run
```
Place all the lib funcs aka copy pasteable as such to other project here:
```bash
lib/bash/func
```
