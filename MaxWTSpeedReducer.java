package mapred;

import java.io.IOException;

// import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
// import org.apache.hadoop.mapreduce.Reducer.Context;

public class MaxWTSpeedReducer
extends Reducer<Text, FloatWritable, Text, FloatWritable> {
	  
@Override
public void reduce(Text key, Iterable<FloatWritable> values,
    Context context)
    throws IOException, InterruptedException {
  
  float maxValue = Float.MIN_VALUE;
  for (FloatWritable value : values) {
    maxValue = Math.max(maxValue, value.get());
  }
  context.write(key, new FloatWritable(maxValue));
}
}
