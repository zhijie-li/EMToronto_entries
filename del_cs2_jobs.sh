#!/usr/bin/env python3
import os,sys
prj='P9'
action='delete_job'

j=[]
if len(sys.argv)>1:
    for i in sys.argv[1:]:

        if len(i)<=4 :
            j.append(i)
        elif '-' in i :
            a,b=i.split('-')
            j.extend(range(int(a),int(b)+1))

for i in j:

    os.system("cryosparcm cli '{}(\"{}\",\"J{}\" )'".format(action,prj,i))
    
