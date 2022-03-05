
# Script 1: making projections from a map
```
#!/usr/bin/env python
#https://blake.bcm.edu/emanwiki/EMAN2/Tutorials/make_a_projection
#prj.py
#usage:
#prj.py map.mrc 15 10 120 
#this tilts the map every 10 degrees, while rotating from 0 to 105 degrees at 15 deg intervals at each tilting angle

#if the systme has imagemagick, uncomment the os.sysmem... lines to generate montage of the projections


from EMAN2 import *
import os

a = EMData()
a.read_image(sys.argv[1])

deg =15
tilt=10
end=180

if len(sys.argv)>2:
    deg=int(sys.argv[2])
if len(sys.argv)>3:
    tilt=int(sys.argv[3])
if len(sys.argv)>4:
    end=int(sys.argv[4])


#sym = Symmetries.get("C3")
#orients = sym.gen_orientations("eman",{"delta":deg, 'inc_mirror':True})
#data = [a.project("standard",t) for t in orients]
#display(data)

altrange=range(0,90+1,tilt)
azrange=range(0,end,deg)
c=0
for alt in altrange:
    for az in azrange: #for C3
        c+=1
        t=Transform({"type":"eman","alt":alt,'az':az})
        d=a.project("standard",t)
        name="{:04d}".format(c)
        name+="_al{}_az{}".format(alt,az)
        name+=".png"
        d.write_image("{}".format(name))
        crop='convert {} -crop 300x300+50+50 +repage {} '.format(name,name)
        #if the systme has imagemagick, uncomment the os.sysmem... lines to generate montage of the projections
        #os.system(crop)


r1=len(altrange)
r2=len(azrange)
command="montage 0*.png -tile {}x{} -background '#ffffff'  -geometry +0+0 proj.png".format(r2,r1)
#if the systme has imagemagick, uncomment the os.sysmem... lines to generate montage of the projections
#os.system(command)
```
