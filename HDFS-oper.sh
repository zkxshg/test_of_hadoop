# show all blocks`info
hdfs fsck / -files -blocks
# mkdir
hadoop fs -mkdir /boks
# copy from local to hdfs
hadoop fs -copyFromLocal /home/zkx/data/1901.txt \ /boks/1901.txt
# see list 
hadoop fs -ls /
# list all blocks in root
hadoop fs -ls file:///
# URL CAT file
export HADOOP_CLASSPATH=/home/zkx/java/hadoop-test.jar
hadoop URLCat hdfs://localhost/boks/sample.txt
# File system Cat file
hadoop FileSystemCat hdfs://localhost/boks/sample.txt
# use seek() to locate in file
hadoop FileSystemDoubleCat hdfs://localhost/boks/1901.txt
# copy file from local to hdfs
hadoop hdfs.FileCopyWithProgress /home/zkx/data/1902.txt hdfs://localhost/boks/1902.txt
# list documents`status
hadoop hdfs.ListStatus hdfs://localhost/ hdfs://localhost/boks
# delete file
hadoop hdfs.DeleteFile hdfs://localhost/boks/1901.txt
# copy document
hadoop distcp hdfs://localhost/boks hdfs://localhost/save
hadoop fs -cp /boks /save
# check file md5
md5sum ./data/sample.txt sample.cp.txt
# checksum of file
hadoop fs -checksum /boks/sample.txt
