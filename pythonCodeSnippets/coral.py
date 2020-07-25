import numpy as np
import matplotlib.pyplot as plt

patterns=[
    #[{"value":"ooo"}, {"statisticCount":0}],
    { "value":"oox", "statisticCount":30 },
    { "value":"oxo", "statisticCount":30 },
    { "value":"xoo", "statisticCount":30 },
    { "value":"oxx", "statisticCount":1 },
    { "value":"xxo", "statisticCount":1 },
    { "value":"xox", "statisticCount":1 },
    { "value":"xxx", "statisticCount":1 },
]

rowNumber = 100
colNumber = 100

field = [[1 for i in range(rowNumber)] for j in range(colNumber)]
for n in range(colNumber):
    field[0][n]=0

statisticSum = 0
for p in patterns:
    statisticSum += p["statisticCount"]

for rowCnt in range(rowNumber):
    randomCount = np.random.rand()*statisticSum
    counter = 0
    patternToUse = {};
    for p in patterns:
        counter += p["statisticCount"];
        if randomCount < counter:
            patternToUse = p 
            break;
    for colCnt in range(1, colNumber):
        if field[rowCnt-1][colCnt] == 0:
            continue
        p = patternToUse["value"]
        print(p)
        
        break;
        #if p == "

print(patternToUse)

print(statisticSum)

plt.imshow(field, cmap='gray')
plt.show()

