# =====================tips ==============================================
# open data by suitable tool
xdg-open data

# export java_hone
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))

# save in PATH
set JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JAVA_HOME
set PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/sbin
export PATH
set CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export CLASSPATH

# export hadoop running java jar
export HADOOP_CLASSPATH=~/desktop/java/java-example.jar

# export hadoop_home
export HADOOP_HOME=/usr/local/hadoop

# export hadoop in path
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME:sbin

# move the file
sudo mv ~/download/1901.gz ./data


# ==================config bashrc==============================================
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# ==================ssh==============================================
# ssh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh localhost

# ==================start bashrc==============================================
# bashrc
source ~/.bashrc

# ==================//config xml==============================================
# mapred
<configuration>
	<property>
  		<name>mapreduce.framework.name</name>
  		<value>yarn</value>
	</property>
</configuration>

# core-site
<configuration>
	<property>
  		<name>fs.defaultFS</name>
  		<value>hdfs://localhost/</value>
	</property>
</configuration>

# hdfs-site
<configuration>
	<property>
  		<name>fs.replication</name>
  		<value>1</value>
	</property>
</configuration>

# yarn-site
<configuration>
<!-- Site specific YARN configuration properties -->
	<property>
  		<name>yarn.resourcemanager.hostname</name>
  		<value>localhost</value>
	</property>
	<property>
  		<name>yarn.nodemanager.aux-services</name>
  		<value>mapreduce_shuffle</value>
	</property>
</configuration>

# ==================start hadoop==============================================
start-dfs.sh
start-yarn.sh
mr-jobhistory-daemon.sh start historyserver
# sbin/mr-jobhistory-daemon.sh start historyserver
jps
# localhost:8088
# ==================hadoop operations=============================================
hadoop fs -mkdir -p /user/data
export HADOOP_CLASSPATH=*.jar
# ==================stop hadoop=============================================
mr-jobhistory-daemon.sh stop historyserver
stop-yarn.sh
stop-dfs.sh
# stop-all.sh
# hadoop namenode -format
# start-all.sh
