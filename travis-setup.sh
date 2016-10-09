#!/bin/bash
set -euo pipefail

# Sets up travis-ci environment for testing bioconda-utils.
#

if [[ $TRAVIS_OS_NAME = "linux" ]]
then
    tag=Linux
else
    tag=MacOSX
fi
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-${tag}-x86_64.sh
sudo bash Miniconda3-latest-${tag}-x86_64.sh -b -p /anaconda
sudo chown -R $USER /anaconda
export PATH=/anaconda/bin:$PATH
conda update -y conda-build

python setup.py install

# TODO: add remaining pip reqs to conda-forge
conda install -y --file conda-requirements.txt
pip install -r pip-test-requirements.txt
pip install -r pip-requirements.txt

mkdir -p /anaconda/conda-bld/osx-64 # workaround for bug in current conda
mkdir -p /anaconda/conda-bld/linux-64 # workaround for bug in current conda
conda index /anaconda/conda-bld/linux-64 /anaconda/conda-bld/osx-64

# setup bioconda channel
conda config --add channels bioconda
conda config --add channels r
conda config --add channels conda-forge
conda config --add channels file://anaconda/conda-bld
