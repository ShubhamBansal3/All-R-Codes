# -*- coding: utf-8 -*-
"""
Created on Thu Dec 12 13:11:13 2019

@author: shubham.bansal
"""

import os
import numpy as np
import pandas as pd

path = "D:\Clustering\BDM Clustering"

os.chdir(path)

os.listdir()

Data= pd.read_csv("DemandData.csv")

HotelCount= pd.read_csv("HotelCount.csv")

Data=Data.merge( HotelCount, how='left', on='bdm' )

Data.iloc[: , 1] = Data.iloc[: , 1]/Data.iloc[: , 7]

Data.iloc[: , 2] = Data.iloc[: , 2]/Data.iloc[: , 7]

Data.iloc[: , 3] = Data.iloc[: , 3]/Data.iloc[: , 7]

Data.iloc[: , 4] = Data.iloc[: , 4]/Data.iloc[: , 7]

Data.iloc[: , 5] = Data.iloc[: , 5]/Data.iloc[: , 7]

Data.iloc[: , 6] = Data.iloc[: , 6]/Data.iloc[: , 7]


import sklearn.preprocessing as pp

ScaledData= pp.scale(Data.iloc[: , 1:7])

ScaledData=pd.DataFrame(ScaledData)

BDM= Data.iloc[: , 0].to_frame()


ScaledData=ScaledData.reset_index(drop=True)

Final = pd.concat([ScaledData,BDM], axis=1)

Final['DemCum'] = Final.iloc[:,0:4].apply(np.sum, axis=1)

Final['RNCum'] = Final.iloc[:,4:6].apply(np.sum, axis=1)

from scipy.spatial.distance import mahalanobis
import scipy as sp

Final1 = Final.iloc[:,7:9]

Sx = Final1.cov().values
Sx = sp.linalg.inv(Sx)

mean = Final1.mean().values

def mahalanobisR(X,meanCol,IC):
    m = []
    for i in range(X.shape[0]):
        m.append(mahalanobis(X.iloc[i,:],meanCol,IC) ** 2)
    return(m)

mR = mahalanobisR(Final1,mean,Sx)

mR = pd.DataFrame(mR)




Final2 = pd.concat([Final1,mR], axis=1)

Final3 = pd.concat([Final2,BDM],axis=1)

Final3.columns = ['DemCum', 'RNCum', 'Mdist', 'bdm']

Final4 = Final3[Final3['Mdist']<=11]

Final5 = Final3[Final3['Mdist']>11]

Final5['Cluster'] = '2'


from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters=3)
kmeans.fit(Final4.iloc[:,0:2])

labels = kmeans.predict(Final4.iloc[:,0:2])
centroids = kmeans.cluster_centers_
Final4 = pd.concat([Final4.reset_index(drop=True),pd.DataFrame(labels)], axis=1)


import seaborn as sns

Final4.columns = ['DemCum', 'RNCum', 'Mdist', 'bdm', 'Cluster']

ax = sns.scatterplot(x="DemCum", y="RNCum", hue="Cluster",data=Final4)




