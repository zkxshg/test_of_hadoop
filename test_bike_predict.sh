# ==================Terminal界面=================
# 安装pyspark和更新配套工具包
sudo pip3 install pyspark
sudo pip3 install -U numpy
sudo pip3 install -U pandas
# 设置环境变量
export PYSPARK_PYTHON=python3
export SPARK_HOME=/home/zkx/sda2/spark-2.4.0-bin-hadoop2.7/bin
# 处理并上传训练集至hdfs
head -3 train.csv
cat train.csv |wc -l
sed 1d train.csv >train_nh.csv
hadoop fs -mkdir /test
hadoop fs -copyFromLocal /home/data/train_nh.csv  /test/train_nh.csv
# 处理并上传待预测数据
head -3 test.csv
sed 1d test_1.csv >test_nh.csv
hadoop fs -copyFromLocal /home/data/test_nh.csv  /test/test_nh.csv
# 进入pyspark
pyspark


# ==================pyspark界面=================

// >>> 从hdfs中载入数据
raw_data = sc.textFile("hdfs://localhost/test/train_nh.csv")
raw_data.take(2)
numRaws = raw_data.count()
numRaws

// >>> 将RDD转换为list
records = raw_data.map(lambda line: line.split(","))
records.first()
from pyspark.ml.linalg import Vectors
from pyspark.ml.regression import DecisionTreeRegressor
data = records.collect()
numColumns = len(data[0])
numColumns

// >>> 处理缺失值并向量化
data1=[]
for i in range(numRaws):
    trimmed = [ each.replace('"', "") for each in data[i] ]
    label = int(trimmed[-1])
    features = map(lambda x: 0.0 if x == "?" else x, trimmed[2:numColumns-3])
    c = (label, Vectors.dense(list(features)))
    data1.append(c)

// >>> 创建dataFrame
df= spark.createDataFrame(data1, ["label","features"])
df.show(10)
df.printSchema()
df.cache()

// >>> 建立特征索引
from pyspark.ml.feature import VectorIndexer
featureIndexer = VectorIndexer(inputCol="features", outputCol="indexedFeatures").fit(df)

// >>> 建立流水线并训练模型
// (trainingData, testData) = df.randomSplit([0.8, 0.2],seed=1234)
from pyspark.ml import Pipeline
dt2 = RandomForestRegressor()
pipeline = Pipeline(stages=[featureIndexer, dt2])
model = pipeline.fit(df)

// >>> 导入并处理待预测数据
test_data = sc.textFile("hdfs://localhost/test/test_nh.csv")
numRaws_t = test_data.count()
test2 = test_data.map(lambda line: line.split(","))
test3 = test2.collect()
numColumns_t = len(test3[0])
data2=[]

// >>> 清理待预测数据并向量化
for i in range(numRaws_t):
    trimmed = [ each.replace('"', "") for each in test3[i] ]
    id = int(trimmed[0])
    features = map(lambda x: 0.0 if x == "?" else x, trimmed[2:numColumns_t])
    c = (id, Vectors.dense(list(features)))
    data2.append(c)

// >>> 创建dataFrame并预测
df2 = spark.createDataFrame(data2, ["id","features"])
result = model.transform(df2)
result.select(['id','prediction']).show(10)

// >>> 保存预测结果
df_result = result.select(['id','prediction']).toPandas()
df_result.to_csv('/opt/datas/result/answer.csv')
