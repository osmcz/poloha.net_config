#!/bin/bash
mypwd=$PWD
cd ~/mod_tile/tiles/
find adresy/ -type f | xargs touch
find budovy/ -type f | xargs touch
find budovy-todo/ -type f | xargs touch
find kct/ -type f | xargs touch
find landuse/ -type f | xargs touch
find parcely/ -type f | xargs touch
find ulice/ -type f | xargs touch
find hills/ -type f | xargs touch
find contours/ -type f | xargs touch
find contours_ortofoto/ -type f | xargs touch
cd default/
find 0/ -type f | xargs touch
find 1/ -type f | xargs touch
find 2/ -type f | xargs touch
find 3/ -type f | xargs touch
find 4/ -type f | xargs touch
find 5/ -type f | xargs touch
find 6/ -type f | xargs touch
find 7/ -type f | xargs touch
find 8/ -type f | xargs touch
find 9/ -type f | xargs touch
find 10/ -type f | xargs touch
cd $mypwd
touch -d '-3 days' ~/mod_tile/tiles/planet-import-complete
