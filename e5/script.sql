-- нет решения (или объяснения?)

-- исходный запрос
SELECT
  T.[Account_Id],
  T.[Date],
  T.[Value]
FROM [Transactions] T
WHERE 
T.[Date] >= '20100101' AND T.[Date] < '20100201'

-- среднее 123 мс
-- Clustered index scan
-- чтений 62823

-- попытка 1

SELECT
    T.[Account_Id],
    T.[Date],
    T.[Value]
FROM
    [Transactions] T
WHERE 
    T.[Account_Id] >= 1 AND
    T.[Date] >= '20100101' AND T.[Date] < '20100201'

-- среднее 125 мс
-- Поиск кластеризованного индекса (казалось бы должно ускорять, но в реальности нет)
-- чтений 62815

-- заменяем условие на BETWEEN
-- T.[Account_Id] BETWEEN 1 AND 1000 AND
-- среднее 133 мс
-- чтений 62763
-- не помогло

-- попытка 2
SELECT
    T.[Account_Id],
    T.[Date],
    T.[Value]
FROM [Transactions] T JOIN [dbo].[Accounts] A ON T.Account_Id=A.Account_Id
WHERE 
    T.[Account_Id] >= 1 AND
    T.[Date] >= '20100101' AND T.[Date] < '20100201'

-- среднее 117 мс
-- Поиск кластеризованного индекса
-- чтений 3787
-- запрос ускорен???