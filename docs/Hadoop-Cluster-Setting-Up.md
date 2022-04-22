# Install Hadoop on Ubuntu Server 18.04 for Bare Metal

## Prerequisite

Update and install dependencies
```
sudo apt update
```
Install Java 8
```
sudo apt install openjdk-8-jdk
```

Install OpenSSH server 
```
sudo apt-get install ssh
sudo apt install openssh-server
```

Configure SSH
```
sudo vim /etc/ssh/sshd_config
```
Change this line "# PubkeyAuthentication yes" to "PubkeyAuthentication yes" (Remove # character) 
Change this line "PasswordAuthentication no" to "PasswordAuthentication yes"

Restart OpenSSH service to apply these changes:
```
sudo service sshd restart
```
## Hostname configuration:

Add hostname of master, datanodes to each other: (Repeat this step for all node)

```
sudo vi /etc/hostnames
```
Example: Add 2 hosts to hostname file
```
192.168.11.182 master
192.168.33.18 datanode1
192.168.11.154 datanode2

```


## Create hadoop user

```
sudo addgroup hadoopgroup
sudo adduser hadoopuser
sudo usermod -g hadoopgroup hadoopuser
sudo groupdel hadoopuser
```
*Required password for hadoopuser*

Switch to hadoopuser:
```
sudo su - hadoopuser
```
## Install Hadoop from Hadoop homepage:


Download Hadoop archive:
```
wget -c -O hadoop.tar.gz http://mirrors.viethosting.com/apache/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz

*Please check the distribution of Hadoop and update download link in below command. Maybe the download link will not available in future*
```
Extract the hadoop installer to *hadoop* folder
```
tar -xvf hadoop.tar.gz
```
Change the name of extracted folder to hadoop name for short:
```
mv hadoop-2.7.7 hadoop
```
## Configuration enviroment variables:

Update *bashrc* file
```
vi ~/.bashrc
```
Copy and paste to the end of *bashrc* file

```
export HADOOP_HOME=/home/hadoopuser/hadoop #Hadoop home path
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/ # Java home path
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
```

Apply the setting:
```
source ~/.bashrc
```

## Configuration for Hadoop
### Configuration enviroment variables for Hadoop

Update the Java path in *hadoop-env.sh* file:

```
vi ~/hadoop/etc/hadoop/hadoop-env.sh
```

Change the line define JAVA_HOME to JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/
*The path same as JAVA_HOME path in bashrc file*
### Configuration core-site.xml

Update the *core-site.xml*. Copy and paste the text below to core-site.xml
```

<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/hadoopuser/tmp</value>
        <description>Temporary Directory.</description>
    </property>
    <property>
            <name>hadoop.proxyuser.hue.hosts</name>
            <value>*</value>
    </property>
    <property>
            <name>fs.defaultFS</name>
            <value>hdfs://master:9000</value>
    </property>
    <property>
            <name>hadoop.http.staticuser.user</name>
            <value>hadoopuser</value>
    </property>
    <property>
            <name>io.compression.codecs</name>
            <value>org.apache.hadoop.io.compress.SnappyCodec</value>
    </property>
    <property>
            <name>hadoop.proxyuser.hue.groups</name>
            <value>*</value>
    </property>
</configuration>


```

### Configuration hdfs-site.xml

Update the *hdfs-site.xml*. Copy and paste the text below to hdfs-site.xml
```

<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
   <property>
        <name>dfs.replication</name>
        <value>2</value>
        <description>Default block replication.
            The actual number of replications can be specified when the file is
            created.
            The default is used if replication is not specified in create time.
        </description>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/home/hadoopuser/hadoop/hadoop_data/hdfs/namenode</value>
        <description>Determines where on the local filesystem the DFS name
            node should store the name table(fsimage). If this is a comma-delimited
            list of directories then the name table is replicated in all of the
            directories, for redundancy.
        </description>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/home/hadoopuser/hadoop/hadoop_data/hdfs/datanode</value>
        <description>Determines where on the local filesystem an DFS data node
            should store its blocks. If this is a comma-delimited list of
            directories, then data will be stored in all named directories,
            typically on different devices. Directories that do not exist are
            ignored.
        </description>
    </property>
    <property>
            <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
            <value>false</value>
    </property>
    <property>
            <name>dfs.webhdfs.enabled</name>
            <value>true</value>
    </property>
    <property>
            <name>dfs.permissions.enabled</name>
            <value>false</value>
    </property>

    <property>
            <name>dfs.namenode.rpc-bind-host</name>
            <value>0.0.0.0</value>
    </property>
    <property>
            <name>dfs.namenode.servicerpc-bind-host</name>
            <value>0.0.0.0</value>
    </property>
    <property>
            <name>dfs.namenode.http-bind-host</name>
            <value>0.0.0.0</value>
    </property>
    <property>
            <name>dfs.namenode.https-bind-host</name>
            <value>0.0.0.0</value>
    </property>
    <property>
            <name>dfs.client.use.datanode.hostname</name>
            <value>true</value>
    </property>
    <property>
            <name>dfs.datanode.use.datanode.hostname</name>
            <value>true</value>
    </property>


</configuration>

```
### Configuration for yarn-site.xml

Update the *yarn-site.xml*. Copy and paste the text below to yarn-site.xml
```

<?xml version="1.0"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->
<configuration>

<!-- Site specific YARN configuration properties -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.resourcemanager.scheduler.address</name>
        <value>master:8030</value>
    </property>
    <property>
        <name>yarn.resourcemanager.address</name>
        <value>master:8032</value>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address</name>
        <value>master:8088</value>
    </property>
    <property>
        <name>yarn.resourcemanager.resource-tracker.address</name>
        <value>master:8031</value>
    </property>
    <property>
        <name>yarn.resourcemanager.admin.address</name>
        <value>master:8033</value>
    </property>
</configuration>

```
### Configuration for salve node

Add hosts to end of slaves configuration file and save.
```
vim ~/hadoop/etc/hadoop/slaves
```
Example: Master can use as a data node so master can include to this configuration:
```
master
datanode1
datanode2

```

### SSH public key setup 
*Required: Setup in all of nodes bidirection: master <=> slave*
```
# Login with hadoopuser
sudo su - hadoopuser

# Generate public and private key
ssh-keygen -t rsa -P ""
cat /home/hadoopuser/.ssh/id_rsa.pub >> /home/hadoopuser/.ssh/authorized_keys 
chmod 600 /home/hadoopuser/.ssh/authorized_keys

# Share ssh key from master - master
ssh-copy-id -i ~/.ssh/id_rsa.pub master

# Share ssh key from master - slave
ssh-copy-id -i ~/.ssh/id_rsa.pub slave-1
```
*Repeat this for slave to connect to master in cluster*

> Test ssh connection using public key authentication
```
# Test ssh connection to master
ssh hadoopuser@master

logout

# Test ssh connection to slave-1
ssh hadoopuser@slave-1

logout
```

## Start name node and other service
Goto $HADOOP_HOME/bin and run:
```
start-all.sh
```
## Start data node on slave:
Go to $HADOOP_HOME and run below comamnd:
*etc/hadoop is a folder contains the configuration of hadoop*
```
cd $HADOOP_HOME
bin/hdfs --config etc/hadoop --daemon start datanode
```
Repeat step on all of remain slave in cluster

## Check the cluster information:
### Check jps:
From master node: 
```
cd $HADOOP_HOME/bin
jps
```
The output of above command be like:
```
2003 NameNode
2412 ResourceManager
2669 Jps
2255 SecondaryNameNode
```
### Test copy file from local:
Creat empty file for test: Ex: Create a 4GB file *upload_test* for test (4096MB) and copy to test_data folder:
```
dd if=/dev/zero of=upload_test bs=1M count=4096
cd $HADOOP_HOME/bin
# Create test_data folder
hdfs dfs -mkdir /test_data

# Upload file to hdfs server
hdfs dfs -copyFromLocal upload_test /test_data

# List the file in test_data
hdfs dfs -ls /test_data
```
### Check dfsadmin
From master node:
Print out DFS Admin information 

```
cd $HADOOP_HOME/bin
hdfs dfsadmin -report
```
The output can be like: 
```
20/02/18 12:28:56 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform… using builtin-java classes where applicable
Configured Capacity: 10340794368 (9.63 GB)
Present Capacity: 8154087424 (7.59 GB)
DFS Remaining: 8154054656 (7.59 GB)
DFS Used: 32768 (32 KB)
DFS Used%: 0.00%
Under replicated blocks: 0
Blocks with corrupt replicas: 0
Missing blocks: 0
Missing blocks (with replication factor 1): 0
 
Live datanodes (1): # Số datanode (slave node) đang hoạt động
Name: 192.168.33.12:50010 (slave)
Hostname: ubuntu-bionic
Decommission Status : Normal
Configured Capacity: 10340794368 (9.63 GB)
DFS Used: 32768 (32 KB)
Non DFS Used: 2169929728 (2.02 GB)
DFS Remaining: 8154054656 (7.59 GB)
DFS Used%: 0.00%
DFS Remaining%: 78.85%
Configured Cache Capacity: 0 (0 B)
Cache Used: 0 (0 B)
Cache Remaining: 0 (0 B)
Cache Used%: 100.00%
Cache Remaining%: 0.00%
Xceivers: 1
Last contact: Tue Feb 18 12:28:56 UTC 2020
```





