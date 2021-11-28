-- запрос
SET dateformat ymd

DECLARE @client INT = 2
DECLARE @date DATETIME = '2020-10-20';

SELECT
	SUM(Value) AS s
FROM
	Docs
WHERE
	[DateTime]<=@date AND [Client_Id]=@client

-- время выполнения ~8 сек

-- предлагаемый индекс
CREATE INDEX [IDX_Docs_Client_Date] ON [dbo].[Docs]
(
	[Client_Id] ASC,
	[DateTime] ASC
)
INCLUDE([Value])

-- время запроса ~5 мс

-- индекс, предложенный SQL-сервером
CREATE NONCLUSTERED INDEX [_dta_index_Docs_5_661577395__K4_K2_5] ON [dbo].[Docs]
(
	[Client_Id] ASC,
	[DateTime] ASC
)
INCLUDE([Value]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
