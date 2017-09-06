#! /usr/bin/env bash

dir=$(cd $(dirname $0) && pwd)
for i in $(ls -d $dir/*/); do
	ln -sfn $dir $GALAXY_ROOT/tools/$(basename $i)
	ln -sfn $dir $GALAXY_ROOT/test-data/$(basename $i)
done

source $GALAXY_ROOT/.venv/bin/activate
pip install planemo bioblend
#planemo test --galaxy_root=$GALAXY_ROOT
planemo serve --galaxy_root=$GALAXY_ROOT
deactivate
