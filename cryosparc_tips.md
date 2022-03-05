# Links
## CryoSPARC job documents

https://guide.cryosparc.com/processing-data/all-job-types-in-cryosparc

https://cryosparc.com/docs/reference/jobs

## "cryosparcm cli" commands

https://guide.cryosparc.com/setup-configuration-and-management/management-and-monitoring/cli



# An example cryoSPARC2 start script (single workstation)
```
#!/bin/bash
#cryoSPARC2.sh
/usr/local/cryosparc2/cryosparc2_master/bin/cryosparcm start
/usr/local/cryosparc2/cryosparc2_worker/bin/cryosparcw connect --worker ThisMachine --master ThisMachine  --update --gpus 0,1 --ssdpath /SSD_disk  --lane default
```

For freshly installed cryosparc2, there may not be a lane already. The above worker startup command should be changed to:

```
/usr/local/cryosparc2/cryosparc2_worker/bin/cryosparcw connect --worker ThisMachine --master ThisMachine   --gpus 0,1 --ssdpath /SSD_disk  --lane default --newlane
```


# Tricks and solutions

## Changing Database location
https://discuss.cryosparc.com/t/how-to-change-database-directory-in-cryosparc-v2/2068/6

## Deleting cache
The location of the cache directory is set in the cryosparcw start command in "--ssdpath /SSD_disk". The name of the cache folder is usually "instance_MachineName:39001".


## Fixing "ERROR: This hostname is already registered! Remove it first."

```
#Assuming current lane is "default"

cryosparcm cli 'remove_scheduler_lane("default")'```

cryosparcm restart

cryosparcw connect --worker WorkerName --master MasterName  --ssdpath /SSD    --newlane --lane default

```

## Removing cryoSPARC from $PATH


With a minor modification to the cryosparcm and cryosparcw scripts, even the cryoSPARC_master/bin and cryoSPARC_master/bin directories can be removed from $PATH:

change
```
script_dir="$( cd "$(dirname "$0")" ; pwd -P )"
```
to
```
script_dir="$(dirname "$(realpath "$0")")"

```

## Changing CUDA version
```
cryosparcw newcuda /usr/local/cuda-11.4
```


## Starting cryosparc2 ipython environment
```
cryosparcm ipython
```

## Starting cryosparc2 ipython environment with direct access to "cli" functions
```
cryosparcm icli
```

## Starting meteor shell
```
cryosparcm mshell
```

## Starting mongo shell
```
cryosparcm mongo
```

## Displaying (end of) log
```
cryosparcm log
```

## Force updating deps(anaconda, meteor, mongo, nodejs, etc.)
```
cryosparcm forcedeps
```

## Creating new user
```
cryosparcm createuser --email <user_email> --password <user_password> --name "<full name>"
```

## Listing users
```
cryosparcm listusers
```


## Backing up and restoring database
```
cryosparcm backup --dir <dir> --file <backup_filename>
```
Eqivalent to:
```
$CRYOSPARC_ROOT_DIR/deps/external/mongodb/bin/mongodump --archive="$dump_path" --host localhost --port $CRYOSPARC_MONGO_PORT
cryosparcm restore --file <backup_filename>
```
Eqivalent to:
```
$CRYOSPARC_ROOT_DIR/deps/external/mongodb/bin/mongorestore --archive="$restore_path" --host localhost --port $CRYOSPARC_MONGO_PORT
```


# "cryosparcm cli" commands

The "cryosparcm cli" commands allow directly calling internal control functions.

https://guide.cryosparc.com/setup-configuration-and-management/management-and-monitoring/cli

## Listing lanes
```
cryosparcm cli 'get_scheduler_targets()'
```
## Deleting a lane
```
cryosparcm cli 'remove_scheduler_lane("LaneName")'
```

## Turning off automatic caching on job start

Source: https://discuss.cryosparc.com/t/how-to-clear-the-cache-in-v2/2161/12
```
cryosparcm cli 'set_project_param_default("PX","compute_use_ssd",False)'
cryosparcm cli 'unset_project_param_default("PX","compute_use_ssd")'
```
## Managing jobs
### Getting job information
```
cryosparcm cli 'get_job("PX","JXXXX", kwargs)'
```
This returns the mongodb entry of the job as a dictionary. The "kwargs" can be a list of keywords of interest, such as "running_at", "job_type", "_id", "job_dir", "output_results", "input_slot_groups", etc.. To find all keys, use this command:
```
cryosparcm cli 'get_job("PX","JXXXX").keys()'
```
Deleting a job
```
cryosparcm cli 'delete_job("PX","JXXXX" )'
```
Clearing a job
```
cryosparcm cli 'delete_job("PX","JXXXX" )'
```

A script for doing these for multiple jobs:

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
            j.extend(range(int(a),int(b)+1))

for i in j:

    os.system("cryosparcm cli '{}(\"P9\",\"J{}\" )'".format(action,i))
```



# Mongo shell commands


```
#start mongo
mongo localhost:$CRYOSPARC_MONGO_PORT/meteor

show dbs
use meteor
show collections

db.<collection>.find()
#for example:
#db.fs.files.find()


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