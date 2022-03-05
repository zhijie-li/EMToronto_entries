# To run scripts without graphical interface of COOT (won't work in Windows)
```
 coot --no-graphic -s scr.py
```

# To get transformation matrix from PDB alignment
Using CCP4 program superpose:
```
$CCP4\6.4\bin\superpose.exe PDB1.pdb PDB2.pdb >out1.log
        Rx         Ry         Rz           T
     -0.234     -0.944      0.231       15.850
     -0.484     -0.093     -0.870       52.586
      0.843     -0.316     -0.435        8.455
```
COOT SSM superimposition would produce:

  -0.2342, -0.9443,  0.2314
  -0.4838, -0.09325,-0.8702
   0.8432, -0.3157, -0.435
 (15.8497, 52.5858,  8.45504)
```

# To transform map in P1 (COOT)
https://www2.mrc-lmb.cam.ac.uk/Personal/pemsley/coot/web/docs/coot.html#Map-Transformation
```

#guile (scheme): (transform-map imol mat trans about-pt radius space-group cell)
#the cell(1) means take the cell parameter of molecule 1 (mandatory). In recent COOT versions the spacegroup and cell arguments have been removed.

#transform a block of map with radius 10, at current view point
transform_map (4, (-0.2342,-0.9443,0.2314,-0.4838, -0.09325,-0.8702,0.8432,-0.3157, -0.435),(15.85,52.59,8.455), rotation_centre(),10,"P 1",cell(1))

#transform a block of map with radius 35, at center of molecule 2
transform_map (4, (-0.2342,-0.9443,0.2314,-0.4838, -0.09325,-0.8702,0.8432,-0.3157, -0.435),(15.85,52.59,8.455), center_of_mass(2),35,"P 1",cell(1))

```

# To transform PDB only
https://www2.mrc-lmb.cam.ac.uk/Personal/pemsley/coot/web/docs/coot.html#transform_002dmolecule_002dby
```
transform_molecule_by(2, -0.2342,-0.9443,0.2314,-0.4838, -0.09325,-0.8702,0.8432,-0.3157, -0.435,15.85,52.59,8.455 )
```

# Masking and transforming portion of a map by matrix from PDB LSQ alignment (COOT)

https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1903&L=ccp4bb&F=&S=&P=172486
```
handle_read_draw_molecule_with_recentre("a.pdb", 1) #the reference pdb, imol 0
handle_read_draw_molecule_with_recentre("H.pdb", 1) #the pdb used for masking and as the moving molecule, imol 1

handle_read_ccp4_map('1.map', 0) #input map, imol 2

#set_last_map_contour_level(0.15)
#set_last_map_sigma_step( 0.010)
#set_last_map_colour( 0.80,  0.00,  0.80)


set_map_mask_atom_radius(3)
mask_map_by_molecule(2,1,1) #mask imol2 around imol 1 to generate imol 3, the masked map around H.pdb

transform_map_using_lsq_matrix(0,'L',1,500,1,'H',1,500,3,rotation_center(),100)  

#lsq match imol 1 H chain to imol 0 L chain. Then rotate&translate imol 3, generate a new map centered at the current rotation center 
#The current rotation center is set on line 2 when reading 'H.pdb'. The transformed map has a maximum radius of 100A around this point. However the saved map is also limited by the unit cell. 
#This generates map imol 4

#Alternatively one can set the center of the new map by specifying the coordinates for the center point:

#transform_map_using_lsq_matrix(0,'L',1,500,1,'H',1,500,3,[0,0,0],100)  #if the point of interest is at [0,0,0]

#improperly set center will cause the map to be cut inside protein


export_map(4,'transposed_masked.map') #save imol 4, the transformed, masked map.



#exit(0) 

#uncomment the above line to run without graphics as: coot --no-graphic -s scr.py
#otherwise one has to type (exit 0) to quit coot
```

# SFALL scripts

Computing an "atom map" from a PDB file
```
sfall xyzin A.pdb mapout atmmap.mrc<<eof
mode atmmap 
resolution 2.5
sfsgroup 1
SYMMETRY 1
cell 250 250 250 90 90 90
end
```
# Computing crystallographic structure factors from a map
```
sfall mapin A.mrc  hklout A.mtz<<eof
mode sfcalc MAPIN
resolution 2.5
sfsgroup 1
SYMMETRY 1
cell 254.4 254.4 254.4 90 90 90
end
```
