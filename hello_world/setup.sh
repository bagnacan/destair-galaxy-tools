#! /usr/bin/env bash
dir=$(cd $(dirname $0) && pwd)
ln -s $dir $GALAXY_ROOT/tools/$(basename $dir)
ln -s $dir $GALAXY_ROOT/test-data/$(basename $dir)

planemo test --galaxy_root=$GALAXY_ROOT
if [[ $? -gt 0 ]]; then	
	exit
fi
echo
echo "test successful - server will start in 5 seconds"
sleep 5
planemo serve --galaxy_root=$GALAXY_ROOT
