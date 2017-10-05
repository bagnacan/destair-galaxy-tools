#! /usr/bin/env bash

dir=$(cd $(dirname $0) && pwd)
for i in $(ls -d $dir/*/); do
	ln -sfn $i $GALAXY_ROOT/tools/$(basename $i)
	ln -sfn $i $GALAXY_ROOT/test-data/$(basename $i)
done

[[ ! -e $GALAXY_ROOT/config/galaxy.ini ]] && cp $GALAXY_ROOT/config/galaxy.ini.sample $GALAXY_ROOT/config/galaxy.ini
sed -i -r 's/^\s*#+(\s*tool_path.+)/\1/' $GALAXY_ROOT/config/galaxy.ini

$GALAXY_ROOT/run.sh
# source $GALAXY_ROOT/.venv/bin/activate
# pip install planemo bioblend
# planemo test --galaxy_root=$GALAXY_ROOT
# planemo serve --galaxy_root=$GALAXY_ROOT
# deactivate
