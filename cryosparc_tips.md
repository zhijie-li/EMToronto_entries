# Links
## CryoSPARC documents

https://guide.cryosparc.com/processing-data/all-job-types-in-cryosparc

https://cryosparc.com/docs/reference/jobs

https://guide.cryosparc.com/setup-configuration-and-management/management-and-monitoring/cli



## Registering a worker
```
#registering a worker to the master
/usr/local/cryosparc2/cryosparc2_worker/bin/cryosparcw connect --worker ThisMachine --master ThisMachine   --gpus 0,1 --ssdpath /SSD_disk  --lane default --newlane
```
```
#update lane
/usr/local/cryosparc2/cryosparc2_worker/bin/cryosparcw connect --worker ThisMachine --master ThisMachine  --update --gpus 0,1 --ssdpath /SSD_disk  --lane default
```
## "ERROR: This hostname is already registered! Remove it first."

```
cryosparcm cli 'remove_scheduler_lane("default")'
```
## Changing CUDA version
```
cryosparcw newcuda /usr/local/cuda-11.4
```


## Changing Database location
https://discuss.cryosparc.com/t/how-to-change-database-directory-in-cryosparc-v2/2068/6

## Deleting cache
The location of the cache directory is set in the cryosparcw start command in "--ssdpath /SSD_disk". The name of the cache folder is usually "instance_MachineName:39001".


## Silent Gctf fail
First find a libcufft.so.8.0 file.  CCPEM comes with one.

```
sudo cp libcufft.so.8.9 /usr/lib/x86_64-linux-gnu/ 
```

## Fixing import pycuda.driver fail

```
#_driver.cpython-37m-x86_64-linux-gnu.so: undefined symbol: _ZSt28__throw_bad_array_new_lengthv
```

For Ubuntu 22, the libstdc++ is in /lib/x86_64-linux-gnu :
```
cd $cryosparc_worker/deps/anaconda/envs/cryosparc_worker_env/lib
mv libstdc++.so.6.0.28  libstdc++.so.6.0.28_backup 
ln -s /lib/x86_64-linux-gnu/libstdc++.so.6.0.30 libstdc++.so.6.0.28 
```
https://discuss.cryosparc.com/t/worker-connect-does-not-work-during-installation/7862


## Removing cryoSPARC from $PATH


change cryosparcm/w :
```
script_dir="$( cd "$(dirname "$0")" ; pwd -P )"
```
to
```
script_dir="$(dirname "$(realpath "$0")")"

```



## cryosparcm commands
```
#getting cryosparc anaconda environment
eval $(cryosparcm env)

# Starting cryosparc2 ipython environment
cryosparcm ipython

## Starting cryosparc2 ipython environment with direct access to "cli" functions
cryosparcm icli


## Starting meteor shell
cryosparcm mshell

## Starting mongo shell
cryosparcm mongo

## Displaying (end of) log
cryosparcm log


## Force updating deps(anaconda, meteor, mongo, nodejs, etc.)
cryosparcm forcedeps

## Creating new user
cryosparcm createuser --email <user_email> --password <user_password> --name "<full name>"

## Listing users
cryosparcm listusers

## Backing up and restoring database
cryosparcm backup --dir <dir> --file <backup_filename>

#Eqivalent to:
$CRYOSPARC_ROOT_DIR/deps/external/mongodb/bin/mongodump --archive="$dump_path" --host localhost --port $CRYOSPARC_MONGO_PORT

cryosparcm restore --file <backup_filename>
#Eqivalent to:
$CRYOSPARC_ROOT_DIR/deps/external/mongodb/bin/mongorestore --archive="$restore_path" --host localobjectRephost --port $CRYOSPARC_MONGO_PORT
```


# "cryosparcm cli" commands

https://guide.cryosparc.com/setup-configuration-and-management/management-and-monitoring/cli

```
## Listing lanes
cryosparcm cli 'get_scheduler_targets()'
cryosparcm cli 'remove_scheduler_lane("LaneName")'

#Source: https://discuss.cryosparc.com/t/how-to-clear-the-cache-in-v2/2161/12
cryosparcm cli 'set_project_param_default("PX","compute_use_ssd",False)'
cryosparcm cli 'unset_project_param_default("PX","compute_use_ssd")'

## Managing jobs
### Getting job information
cryosparcm cli 'get_job("PX","JXXXX", kwargs)'

#This returns the mongodb entry of the job as a dictionary. The "kwargs" can be a list of keywords of interest, such as "running_at", "job_type", "_id", "job_dir", "output_results", "input_slot_groups", etc.. To find all keys, use this command:

cryosparcm cli 'get_job("PX","JXXXX").keys()'
cryosparcm cli 'delete_job("PX","JXXXX" )'
cryosparcm cli 'delete_job("PX","JXXXX" )'
```

# A script for doing these for multiple jobs:

```
#!/usr/bin/env python3
import os,sys

action='delete_job'

j=[]
if len(sys.argv)>1:
    for i in sys.argv[1:]:

        if len(i)<=4 :
            j.append(i)
        elif '-' in i :
            a,b=i.split('-')
            j.extend(range(int(a),int(b)+1))In [28]: a

for i in j:

    os.system("cryosparcm cli '{}(\"P9\",\"J{}\" )'".format(action,i))
```



# Mongo shell commands


```
#start mongo
mongo localhost:$CRYOSPARC_MONGO_PORT/meteor
#alternatively
cryosparcm mongo

show dbs
use meteor
show collections

db.<collection>.find()
#for example:
#db.fs.files.find()
db.workspaces.find({'uid':'W1',"project_uid" : "P17"})

#showing project settings/defaults
db.projects.findOne({'uid':'P17'})


db.cache_files.stats({ scale : 1024 })
db.config.stats({ scale : 1024 })
db.events.stats({ scale : 1024 })
db.file_index.stats({ scale : 1024 })
db.fs.chunks.stats({ scale : 1024 })
db.fs.files.stats({ scale : 1024 })
db.int_curate_exposures.stats({ scale : 1024 })
db.jobs.stats({ scale : 1024 })
db.meteor_accounts_loginServiceConfiguration.stats({ scale : 1024 })
db.projects.stats({ scale : 1024 })
db.roles.stats({ scale : 1024 })
db.sched_config.stats({ scale : 1024 })
db.users.stats({ scale : 1024 })
db.workspaces.stats({ scale : 1024 })


db.events.find().sort({_id:-1})


db.events.find({created_at:{$lt:new Date((new Date())-1000*60*60*24*14)}}).sort({created_at:-1})
from bson.objectid import ObjectId

db.events.deleteMany({created_at:{$lt:new Date((new Date())-1000*60*60*24*7)}})
db.notifications.deleteMany({created_at:{$lt:new Date((new Date())-1*60*60*24*1)}})

db['fs.chunks'].remove({files_id:my_id});
db['fs.files'].remove({_id:my_id});

/usr/local/cryosparc2/cryosparc2_master/deps/external/mongodb/bin/mongofiles --host localhost:39001 --db fs.files delete logo_susan1225.png
/usr/local/cryosparc2/cryosparc2_master/deps/external/mongodb/bin/mongofiles --host localhost:39001 --db fs.files search image.png
mongofiles -d records search corinth


mongofiles --host localhost:39001 -d meteor get P1_J2*


db.fs.chunks.find({files_id: ObjectId("5bf1c7a90398a21465aed0b2")})


db.runCommand({collStats:'fs.chunks'})

#defrag the gridfs:

db.runCommand({compact:'fs.chunks', force:true})
```


# Diretcly accessing the Meteor Mongodb using pymongo
See:
https://pymongo.readthedocs.io/en/stable/tutorial.html
```
from pymongo import MongoClient
from gridfs import GridFS

#get databse 'meteor'
db=MongoClient('mongodb://localhost:39001')['meteor']
#alternatively:
db=MongoClient('localhost',39001)['meteor']

#get collection
db.list_collection_names()
cl=db.get_collection('jobs')
cl=db['jobs']
objectRep
a=cl.find_one({"project_uid" : "P1","uid" : "J1"})

print( a['job_type'])
import pprint
pprint.pprint(a)

posts = db.posts





gridfs = GridFS(db)
```


# The 'gridfsdata_0' files (database dumps in job directories)

These files are generated by pickle.dump() the data files. These files are the images/graphs generated in the jobs. These files are originally saved in the mongoDB gridFS.  The mongoDB['fs.files'] contains meta information of these files. The actual data files are saved in mongoDB['fs.chunks'].  They are referred by the mongoDB['events'] entries, which are the text displayed in the web interface of the running job.

If the intermediate results are not turned off by 
```
cryosparcm cli "set_project_param_default($prj, 'intermediate_plots', False)"
```
then there will be many intermediate plots and graphs saved in both the database and the gridfsdata dumps.
 

To load the pickle:
```
pf=open('gridfsdata_0','rb')
a=pickle.load(pf)
# a will be a list, each entry of it will be a dict
# each dict has four keys:
#a.keys()
# dict_keys(['_id', 'filename', 'data', 'job_uid'])
# the filetype information is lost, therefore it is better to extract the data directly from the mongoDB:

filelist=list( db['fs.files'].find({'project_uid':P, 'job_uid':J} ) )
#this list is a list of dicts too
for b in filelist:
    print(b['contentType'],b['filename'])

print(filelist[0].keys())

#Out[28]: dict_keys(['_id', 'filename', 'contentType', 'chunkSize', 'md5', 
#                    'length', 'uploadDate', 'project_uid', 'job_uid'])



for k in filelist[0]:
    print (k,filelist[0][k])
'''
_id 625dc2f3db692bc69d67880d
filename image.png
contentType image/png
chunkSize 2096128
md5 bacc69dd2811da9acd832744410ba2b2
length 28369from bson.objectid import ObjectId

uploadDate 2022-04-18 19:58:43.936000
project_uid P17
job_uid J208
'''

```

To search a file by the 'fileid' listed in a db['events'] entry:
```


e=list(db['events'].find({'project_uid':'P17','job_uid':'J208'},sort=[('created_at', pymongo.ASCENDING)] ))

'''
one of the image records:
'imgfiles': [{'filetype': 'png', 'filename': 'P17_J208_2d_classes_for_iteration_20.png', 'fileid': '625dc7a9db692bc69d67889b'}, 
{'filetype': 'pdf', 'filename': 'P17_J208_2d_classes_for_iteration_20.pdf', 'fileid': '625dc7a9db692bc69d67889d'}],
'''

from bson.objectid import ObjectId
a=db['fs.files'].find_one({'_id':ObjectId('625dc7a9db692bc69d67889b')})

#search by file name works too:
a=db['fs.files'].find_one({'filenmae':'P17_J208_2d_classes_for_iteration_20.png'})


```


## Setting up worker-only

https://linuxhint.com/run-exit-ssh-command/
https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication/

Master runs jobs through SSH on workers. In order to allow master send ssh strings to worker, RSA authentication needs to be setup.

On both master and worker computer, install ssh:
```
sudo apt install openssh-server


sudo vi /etc/ssh/sshd-config
#uncomment this line:
# PasswordAuthentication yes
#Then:
sudo service ssh restart

```

On master computer under the user who installed cryosparc:
```
ssh-keygen -t rsa
#put empty passphrase

ssh-copy-id cryosparcw_username@x.x.x.x
#login with ssh password 
```
If the master uses a alias, make sure the worker has it listed in /etc/hosts:

```
192.168.1.105   cs_master
```



