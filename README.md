<div id="top"></div>

# Tools

This repository contains the de.STAIR tools that are incorporated in the
[Galaxy workflow generator](https://github.com/destairdenbi/galaxy-workflow-generator),
to assist users in the analysis of RNA-Seq and BS/RRBS-Seq data.

- [How to contribute](#how-to-contribute)
  - [Set up the Galaxy environment](#set-up-the-galaxy-environment)
  - [Set up the de.STAIR tools](#set-up-the-destair-tools)
  - [Run the Galaxy framework](#run-the-galaxy-framework)


## How to contribute

Tools can be tested, modified, and extended. The following sections will help
you set up the Galaxy framework to contribute to the tools.
<p align="right"><a href="#top">&#x25B2; back to top</a></p>


### Set up the Galaxy environment

Create a directory for the Galaxy repository
```
$ export GALAXY_ROOT=/path/to/galaxy
```

Clone the Galaxy repository into the directory
```
$ git clone https://github.com/galaxyproject/galaxy.git $GALAXY_ROOT
```

Enter in the Galaxy repository, and checkout version 19.01
```
$ cd $GALAXY_ROOT
$ git checkout v19.01
```
<p align="right"><a href="#top">&#x25B2; back to top</a></p>


### Set up the de.STAIR tools

Create a directory for the de.STAIR Galaxy tools repository
```
$ export DESTAIR_GALAXY_TOOLS=/path/to/destair-galaxy-tools
```

Clone the de.STAIR Galaxy tools repository
```
$ git clone https://github.com/destairdenbi/galaxy-tools.git $DESTAIR_GALAXY_TOOLS
```

Set up the de.STAIR tools into the cloned Galaxy repository
```
$ $DESTAIR_GALAXY_TOOLS/setup.sh
```
<p align="right"><a href="#top">&#x25B2; back to top</a></p>


### Run the Galaxy framework

Run the Galaxy launch script to verify the Galaxy framework setup and the inclusion of the new tools
```
$ $GALAX_ROOT/run.sh
```
<p align="right"><a href="#top">&#x25B2; back to top</a></p>
