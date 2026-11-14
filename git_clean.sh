#!/bin/bash

rm -rf .git
git init
git remote add origin git@github.com:ucla-physicalsciences/cta-psct.physics.ucla.edu.git
git checkout -b main
git fetch
git reset --hard origin/main
