package mapred;
import java.io.IOException;

//import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
// import org.apache.hadoop.mapreduce.Mapper.Context;

public class MaxWTSpeedMapper
	  extends Mapper<LongWritable, Text, Text, FloatWritable> {

	  private static final int MISSING = 9999;
	  
	  @Override
	  public void map(LongWritable key, Text value, Context context)
	      throws IOException, InterruptedException {
	    
	    String line = value.toString();
	    String[] info = line.split(",");
	    String ID;
	    float WTSpeed;
	    ID = info[0];
	    WTSpeed = Float.parseFloat(info[2]);
	    
	    if (ID != "" && WTSpeed!= MISSING) {
	      context.write(new Text(ID), new FloatWritable(WTSpeed));
	    }
	  }
}
