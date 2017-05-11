#! /usr/bin/env bash

if [ $1 == "planemo" ]; then
	cd $(dirname $0)
	echo "hello world" > hello_world.in
	echo "hello mars" > hello_world.out
	planemo tool_init --force --id 'hello_world' --name 'hello world' --example_command 'hello_world.sh -i hello_world.in -o hello_world.out' --example_input test-data/hello_world.in --example_output test-data/hello_world.out --test_case --help_from_command './hello_world.sh -h'
	sed -i -E 's/<command>(.*)/<command interpreter="bash">\1/' hello_world.xml
	exit 0
fi

usage() {
	echo $1
	echo $(basename $0)" replaces the word world with mars" 
	echo "usage:"
	echo $(basename $0)" -i <FILE> -o <FILE>"
	exit 1
}

input=''
output=''
help=0
while getopts i:o:h ARG; do
	case $ARG in
		i) input=$OPTARG;;
		o) output=$OPTARG;;
		h) help=1;;
		*) usage;;
	esac
done

if [ $help -gt 0 ]; then
	usage
fi
if [ ! -e $input ]; then
	usage "file does not exists: $input"
fi
if [ ! -d $(dirname $output) ]; then
	usage "directory does not exists: "$(dirname $output)
fi

cat $input | sed 's/world/mars/g' > $output
