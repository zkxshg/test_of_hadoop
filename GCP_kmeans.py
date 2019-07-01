# coding=utf-8
import pyspark
from pyspark.ml.linalg import Vectors
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import random as rand
import datetime
# from sklearn import datasets

def simple_km(ori, n_clusters, max_iter):
    x = 1
    attr_num = len(ori[0])
    tup_num = len(ori)
    clu_arr = [tup_num]  # save the cluster of each tuple
    count_arr = [n_clusters]  # save the total number of each cluster
    mean_arr = []  # save the mean position
    change_num = tup_num + 1  # number of changed points in each iter
    # dist_arr = [n_clusters]
    # ===========================initial ==========================
    for i in range(0, n_clusters):
        r = np.random.randint(0, tup_num-1)
        r_exist = False
        # if duplicate, sample again
        for j in mean_arr:
            if np.equal(ori[r], j).all():
                r_exist = True
                r = np.random.randint(0, tup_num - 1)
                break
        mean_arr.append(ori[r])
    # print(mean_arr)
    for i in range(0, tup_num):
        clu_arr.append(0)

    # =========================iteration ================================
    iter_num = 0
    change_con = int(tup_num*0.001)
    while iter_num < max_iter and change_num > change_con:
        #  assign
        clu_arr, change_num = assign(mean_arr, ori, clu_arr)
        #  update
        mean_arr = update(ori, clu_arr, n_clusters)
        # print(mean_arr)
        iter_num += 1
    print(clu_arr)
    print("=========")
    print(change_num)
    SSE = 0
    for i in range(0, tup_num):
        SSE += np.square(np.linalg.norm((ori[i] - mean_arr[clu_arr[i]])))
    print("SSE is : ")
    print(SSE)
    return x


# =========================assign================================
def assign(mean_arr, ori, pre_clu):
    tup_num = len(ori)
    n_clusters = len(mean_arr)
    clu_arr = []  # save the cluster of each tuple
    change_num = 0  # number of changed points in each iter
    for i in range(0, tup_num):
        clu_arr.append(0)
    for i in range(0, tup_num):
        min_in = -1
        # min_dist = np.linalg.norm((ori[i] - mean_arr[0]))
        # min_dist = np.dot(ori[i], mean_arr[0]) / (np.linalg.norm(ori[i]) * (np.linalg.norm(mean_arr[0])))
        min_dist = 999999
        for j in range(0, n_clusters):
            dist = np.linalg.norm((ori[i] - mean_arr[j]))
            # dist = np.dot(ori[i], mean_arr[j]) / (np.linalg.norm(ori[i]) * (np.linalg.norm(mean_arr[j])))
            # dist = np.square(np.dot(ori[i], mean_arr[j]))
            if dist < min_dist:
                min_in = j
                min_dist = dist
        # print(min_dist)
        clu_arr[i] = min_in
        if clu_arr[i] != pre_clu[i]:
            change_num += 1
    return clu_arr, change_num


# =========================update================================
def update(ori, clu_arr, n_clusters):
    mean_arr = []
    for i in range(0, n_clusters):
        sum_num = 0
        sum_arr = np.zeros(len(ori[0]))
        for j in range(0, len(ori)):
            if clu_arr[j] == i:
                sum_num += 1
                sum_arr = np.add(sum_arr, ori[j])
                # print(sum_arr)
        mean_arr.append(sum_arr/sum_num)
    return mean_arr


if __name__=='__main__':
    # 參數初始化
    output_file = 'data_type.xls'  # 結果保存路徑
    k = 20  # 聚類類別
    iteration = 300  # 最大迭代次數
    # ==============================Iris=======================
    sc = pyspark.SparkContext()
    raw_data  = sc.textFile('gs://dataproc-0887bd27-1afb-42eb-b63b-cc545d69fbf3-na-northeast1/c20d6n200000.csv')
    numRaws = raw_data.count()
    records = raw_data.map(lambda line: line.split(","))
    data = records.collect()
    numColumns = len(data[0])
    arr = np.array(data)
    arr= arr.astype(float)
    data = arr
    # labels = iris['target']
    # data = 1.0 * (data - data.mean()) / data.std()
    # ==============================abalone=======================
    # data = np.loadtxt('abalone.csv', delimiter=",", skiprows=1, usecols=(1, 2, 3, 4, 5, 6, 7))
    # labels = np.loadtxt('abalone.csv', delimiter=",", dtype=str, usecols=(0))
    # data = 1.0 * (data - data.mean()) / data.std()
    # print(labels)
    start_time = datetime.datetime.now()
    model = simple_km(data, k, iteration)
    end_time = datetime.datetime.now()
    print(end_time - start_time)

    # print(list(set(labels)))
    # 數據預處理
    # print(np.isnan(data).any())
    # print(data.isnull().sum())
    # data.fillna(0)
    # print(data.isnull().sum())
    # print(np.isnan(data).any())
    #  #数据标准化
