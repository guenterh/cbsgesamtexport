#!/usr/bin/env bash



BASE_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

TARGET_HOST=sb-uwf1.swissbib.unibas.ch
USER=swissbib
TARGET_DIR=/swissbib_index/cbsCatcher
IMAGETAR=gesamtexport.tar
IMAGENAME=gesamtexport

cd $BASE_DIR

echo "build latest image gesamtexport"

docker build -t $IMAGENAME .

echo "save latest image gesamtexport as tar file"
docker save $IMAGENAME --output $IMAGETAR

echo "cp tar file to target host"
scp $IMAGETAR $USER@$TARGET_HOST:$TARGET_DIR

echo "stop container if running on the target host"
ssh $USER@$TARGET_HOST "cd $TARGET_DIR; docker container stop $IMAGENAME"

echo "rm already existing image o target host"
echo "load just created image on target host"
ssh $USER@$TARGET_HOST "cd $TARGET_DIR; docker image rm $IMAGENAME; docker load --input $IMAGETAR"



rm $IMAGETAR

ssh $USER@$TARGET_HOST "rm $TARGET_DIR/$IMAGETAR"