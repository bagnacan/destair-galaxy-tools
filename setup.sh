#! /usr/bin/env bash

dir=$(cd $(dirname $0) && pwd)
for i in $(ls -d $dir/*/); do
	ln -sfn $dir $GALAXY_ROOT/tools/$(basename $i)
	ln -sfn $dir $GALAXY_ROOT/test-data/$(basename $i)
done

# source $GALAXY_ROOT/.venv/bin/activate
# deactivate

planemo test --galaxy_root=$GALAXY_ROOT
if [[ $? -gt 0 ]]; then	
	echo "test failed"
	exit
fi
echo
echo "test successful - server will start in 5 seconds"
sleep 5
planemo serve --galaxy_root=$GALAXY_ROOT
