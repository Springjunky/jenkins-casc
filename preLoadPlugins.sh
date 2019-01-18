#!/bin/bash

set -e
if [ ! -f ./jenkins.env ]; then
  echo "run prepareSetup.sh first to set your Jenkins-Version"
  exit -1
fi

. ./jenkins.env  

MAJOR_MINOR=${MAJOR}.${MINOR}

plugin_dir=jenkins/plugins-${MAJOR_MINOR}


mkdir -p ${plugin_dir}

installPlugin() {
  if [ -f ${plugin_dir}/${1}.hpi -o -f ${plugin_dir}/${1}.jpi ]; then
    if [ "$2" == "1" ]; then
      return 1
    fi
    echo "Skipped: ${plugin_dir}/$1 (already installed)"
    return 0
  else
    echo "Downloading: https://updates.jenkins-ci.org/${MAJOR_MINOR}/latest/${1}.hpi to ${plugin_dir}"
    curl -L --silent --output ${plugin_dir}/${1}.hpi  https://updates.jenkins-ci.org/${MAJOR_MINOR}/latest/${1}.hpi
    return 0
  fi
}

for plugin in  $(cat jenkins/plugins.txt)
do
    installPlugin "$plugin"
done

changed=1
maxloops=100

while [ "$changed"  == "1" ]; do
  echo "Check for missing dependecies ..."
  if  [ $maxloops -lt 1 ] ; then
    echo "Max loop count reached - probably a bug in this script: $0"
    exit 1
  fi
  ((maxloops--))
  changed=0
  for f in ${plugin_dir}/*.hpi ; do
    # without optionals
    #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    # with optionals
    deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    for plugin in $deps; do
      installPlugin "$plugin" 1 && changed=1
    done
  done
done

COUNT=$(find ${plugin_dir} -name *.hpi | wc -l)
if [ $COUNT -gt 0 ] ; then 
	echo "Renaming all .hpi to .jpi"
	for file in $(ls ${plugin_dir}/*.hpi)
	do
	  mv $file  ${file%.*}.jpi 
	done
fi	




echo "all done"