import numpy as np
import matplotlib.pyplot as plt

patterns=[
    #[{"value":"ooo"}, {"statisticCount":0}],
    { "value":[False, False, True],  "statisticCount":100 },
    { "value":[False, True,  False], "statisticCount":100 },
    { "value":[True,  False, False], "statisticCount":100 },
    #{ "value":[False, True,  True],  "statisticCount":10 },
    #{ "value":[True,  True,  False], "statisticCount":10 },
    #{ "value":[True,  False, True],  "statisticCount":10 },
    #{ "value":[True,  True,  True],  "statisticCount":1 },
]

rowNumber = 1000
colNumber = 1000
numberOfRays = 10

field = [[False for i in range(rowNumber)] for j in range(colNumber)]
for n in range(0, colNumber, numberOfRays):
    field[0][n] = True

statisticSum = 0
for p in patterns:
    statisticSum += p["statisticCount"]

for rowCnt in range(1, rowNumber-1):
    for colCnt in range(1, colNumber-1):
        if rowCnt==1 or rowCnt % 50 == 0:
            randomCount = np.random.rand()*statisticSum
            counter = 0
            patternToUse = {}
            for p in patterns:
                counter += p["statisticCount"];
                if randomCount < counter:
                    patternToUse = p 
                    break
            print(rowCnt)
            print(patternToUse)
        if field[rowCnt-1][colCnt] == True:
            p = patternToUse["value"]
            field[rowCnt][colCnt-1] = field[rowCnt][colCnt-1] or p[0]
            field[rowCnt][colCnt]   = field[rowCnt][colCnt]   or p[1]
            field[rowCnt][colCnt+1] = field[rowCnt][colCnt+1] or p[2]
            #print(patternToUse)

plt.imshow(field, cmap='gray')
plt.show()

