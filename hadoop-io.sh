# compress and system.out
echo "hello hadoop" | hadoop io.StreamCompressor org.apache.hadoop.io.compress.GzipCodec | gunzip
# depend on extension to choose the Codec
hadoop io.FileDecompressor /home/zkx/data/1902.txt.gz
# compress the mapreduce output and system out
hadoop com.hadoop.j2h.MaxTemperatureWithCompression /home/zkx/data/1902.gz output
# write sequence file
hadoop io.SequenceFileWriteDemo numbers.seq
# read sequence file
hadoop io.SequenceFileReadDemo numbers.seq
# -text show SequenceFile
hadoop fs -text numbers.seq |head
# use hadoop default jar to sort/merge sequece file
hadoop jar \
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
>  sort -r 1 \
>  -inFormat org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat \
>  -outFormat org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat \
>  -outKey org.apache.hadoop.io.IntWritable \
>  -outValue org.apache.hadoop.io.Text \
> numbers.seq sorted
