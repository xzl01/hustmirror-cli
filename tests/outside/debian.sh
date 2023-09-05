#!/usr/bin/env bash
set -e

ROOT_DIR=$(realpath `pwd`/../../)

images="
debian:12-slim
debian:11-slim
debian:10-slim
debian:sid-slim
debian:testing-slim
"

for image in $images
do
  printf "TESTING $image...\t"
  LDIR=$ROOT_DIR/tests/log/${image/:/_}
  rm -rf $LDIR
  mkdir -p $LDIR


  if echo $image | grep "sid" >/dev/null; then
    docker run -it --rm \
      -v $ROOT_DIR/output:/hustmirror \
      -v $ROOT_DIR/tests/inside:/hmtest \
      -v $LDIR:/hmtest_log \
      -e "HM_DEBIAN_SID=true" \
      $image bash -c "/hmtest/debian.sh >/hmtest_log/output.log 2>&1" \
      > $LDIR/docker_output.log 2> $LDIR/docker_output.err || true
  else
    docker run -it --rm \
      -v $ROOT_DIR/output:/hustmirror \
      -v $ROOT_DIR/tests/inside:/hmtest \
      -v $LDIR:/hmtest_log \
      $image bash -c "/hmtest/debian.sh >/hmtest_log/output.log 2>&1" \
      > $LDIR/docker_output.log 2> $LDIR/docker_output.err || true
  fi


  if [ -f $LDIR/pass ]; then
    printf "PASS \n"
  else
    printf "\033[0;31m FAIL!!! \033[0m \n"
  fi
done
