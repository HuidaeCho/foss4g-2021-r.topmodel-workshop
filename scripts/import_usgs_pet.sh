#!/bin/sh
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

g.region n=90 s=-90 e=180 w=-180 res=1
for i in et*.tar.gz; do
    tar xvf $i;
    name=$(basename $i | sed 's/\..*//')
    r.in.gdal -o --o input=$name.bil output=tmp
    rm $name.???
    r.mapcalc expression="$name=tmp" --o
done
g.remove -f type=raster name=tmp
