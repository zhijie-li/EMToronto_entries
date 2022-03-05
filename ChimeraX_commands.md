## General display
```
lighting full; lighting simple; lighting soft;
background white;set bgColor white;

set silhouette  true;
set selectionWidth 1;
size stickRadius 0.01;
```

## Open files
```
close all

open 6eyd; open 3983 from emdb

open reflections.mtz structureModel #1

fitmap #1 inMap #2 moveWholeMolecules false
```

## Maps
```
volume selMaps appearance \"Airways II\"
volume #1 level 0.28
volume orthoplanes  xyz
```

## Saves
```
save image /cavity_1.png width 1800 height 1800
save session R77.cxs
save 829b.pdb format pdb models #1.3
```

## Clipper & ISOLDE
```
clipper associate #2 toModel #1

clipper isolate atoms [surroundDistance a number] [contextDistance a number] [maskRadius a number] [hideSurrounds true or false] [focus true or false] [includeSymmetry true or false]
clipper spotlight radius 20.00
clipper spotlight [models [enable]] [radius a number]

isolde start
isolde sim start #1
isolde sim stop #1
```

## Distances
```
distance style color #3465a4
distance style symbol false
```

## Movies
```
movie record
turn y 2 180
wait 180
movie encode movie1.mp4
```
