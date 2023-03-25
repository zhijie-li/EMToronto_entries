## atom selection
https://www.cgl.ucsf.edu/chimerax/docs/user/commands/atomspec.html

```
#model/chain:residue@atom

#1,2/B-D,F:50,70-85@ca
helix & :arg,lys

name tm1 /a:34-64

~@@display #undisplayed
@@num_alt_locs>1 
@@bfactor>=20 & @@bfactor<=40

#a level symbol: @ (atom-based cutoff), : (residue-based), / (chain-based), or # (atomic-model-based)

@nz  @<  3.8       #  __atoms__    within 3.8 Å of atoms named NZ
#1:gtp  :<  10.5   #  __residues__ with any atom within 10.5 Å of any atom in GTP residue(s) of model 1
#1:gtp  :>  10.5     
```
__atom types__:
https://www.cgl.ucsf.edu/chimerax/docs/user/atomtypes.html

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
