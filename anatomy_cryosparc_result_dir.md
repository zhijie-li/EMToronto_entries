# The model ( starting from cryoEM movies)

Import movies => [rigid motion | patch motion] =>[CTFfind | gCTF | patch CTF ( -> patch CTF extract) ] => particle picking[blob | template | topaz |deep ] 

=> extract actual particle images, save in mrc stacks => local motion ( reads movies, update )


## What takes long / are worth saving:
### data
[.cs] movies:uids 

[MRC] Micrographs from [rigid motion | patch motion]

[.cs, .npy] CTF results 

[MRC] particle stacks from extraction / local motion

[.cs] particle uids, locations

### results

2D class averages, PDF version, final MRC

3D map, particle .cs

