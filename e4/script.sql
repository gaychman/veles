-- с оконными функциями

SET dateformat ymd
DECLARE @date DATE = '2021-10-14';

SELECT
	i.[Name], NumberedRows.[Value], NumberedRows.[Date]
FROM
	Instruments i JOIN 
	(
		SELECT 
			Instrument_Id,
			[Value],
			[Date],
			ROW_NUMBER() OVER(PARTITION BY Instrument_Id ORDER BY [Date] DESC) RN
		FROM
			Rates
		WHERE
			[Date] <= @date
	) NumberedRows ON NumberedRows.Instrument_Id = i.Id
WHERE
	NumberedRows.RN = 1