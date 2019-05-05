#!/usr/bin/env bash



BASE_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

TARGET_HOST=sb-uwf2.swissbib.unibas.ch
USER=swissbib
TARGET_DIR=/swissbib_index/apps/cbs
DATA_DIR=$TARGET_DIR/data
IMAGETAR=gesamtexport.tar
IMAGENAME=gesamtexport

cd $BASE_DIR

echo "build latest image gesamtexport"

docker build --no-cache -t $IMAGENAME .
#docker build -t $IMAGENAME .

echo "save latest image gesamtexport as tar file"
docker save $IMAGENAME --output $IMAGETAR


for host in sb-uwf1.swissbib.unibas.ch sb-uwf2.swissbib.unibas.ch
do


    ssh $USER@$host "[ ! -d ${DATA_DIR} ]  &&  mkdir -p ${DATA_DIR}"

    echo "cp tar file to target host"
    scp $IMAGETAR $USER@$host:$TARGET_DIR

    echo "stop container if running on the target host"
    ssh $USER@$host "cd $TARGET_DIR; docker container stop $IMAGENAME"

    echo "rm already existing image o target host"
    echo "load just created image on target host"
    ssh $USER@$host "cd $TARGET_DIR; docker image rm $IMAGENAME; docker load --input $IMAGETAR"

    ssh $USER@$host "rm $TARGET_DIR/$IMAGETAR"


done

rm $IMAGETAR
