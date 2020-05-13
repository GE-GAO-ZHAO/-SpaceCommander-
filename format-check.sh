#!/usr/bin/env bash
orgin=`git rev-parse --show-toplevel`
if [ ! -d .git ];
then exit 0
fi
if [ -d .spacecommander ];
then exit 0
fi
mkdir .spacecommander
cd .spacecommander
git clone git@git.koolearn-inc.com:k12/iOS/SpaceCommand.git spacecommander
cd $orgin
bash "$(pwd)/.spacecommander/spacecommander/setup-repo.sh"
exit 0
