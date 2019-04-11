# ==================Terminal界面=================
# 安装pyspark和更新配套工具包
sudo pip3 install pyspark
sudo pip3 install -U numpy
sudo pip3 install -U pandas
# 设置环境变量
export PYSPARK_PYTHON=python3
export SPARK_HOME=/home/zkx/sda2/spark-2.4.0-bin-hadoop2.7/bin
# 处理并上传训练集至hdfs
head -3 air_answer_2.csv
cat air_answer_2.csv |wc -l
sed 1d air_answer_2.csv >air_nh.csv
hadoop fs -mkdir /test
hadoop fs -copyFromLocal /home/data/air_nh.csv  /test/air_nh.csv

# 进入pyspark
pyspark

# ==================pyspark界面=================

// >>> 从hdfs中载入数据
raw_data = sc.textFile("hdfs://localhost/test/air_nh.csv")
raw_data.take(2)
numRaws = raw_data.count()
numRaws


// >>> 将RDD转换为list
records = raw_data.map(lambda line: line.split(","))
records.first()
from pyspark.ml.linalg import Vectors
from pyspark.ml.fpm import FPGrowth
data = records.collect()
numColumns = len(data[0])
numColumns

// >>> 处理缺失值并向量化
data1=[]
for i in range(numRaws):
    trimmed = [ each.replace('"', "") for each in data[i] ]
    id = int(trimmed[0])
    features = trimmed[1:numColumns]
    c = (id, features)
    data1.append(c)


// >>> 创建dataFrame
df_fp= spark.createDataFrame(data1, ["id","features"])
df_fp.show(10)
df_fp.printSchema()
df_fp.cache()

// >>> 使用FPGrowth模型求解
fpGrowth = FPGrowth(itemsCol="features", minSupport=0.5, minConfidence=0.6)
model = fpGrowth.fit(df_fp)
model.freqItemsets.show()
model.associationRules.show()
model.transform(df_fp).show()
