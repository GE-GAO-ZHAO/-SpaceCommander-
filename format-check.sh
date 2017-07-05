#!/usr/bin/env bash
orgin=`git rev-parse --show-toplevel`
if [ ! -d .git ];
then exit 0
fi
if [ -d .spacecommander ];
then rm -rf .spacecommander
fi
mkdir .spacecommander
cd .spacecommander
git clone git@ofordcode.ofo.so:pengfeng/objc-format-check.git spacecommander
cd $orgin
bash "$(pwd)/.spacecommander/spacecommander/setup-repo.sh"
exit 0
