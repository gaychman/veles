-- первая версия
IF OBJECT_ID('[dbo].[TestDocs_Insert]') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[TestDocs_Insert] AS RETURN (-1)')
GO
ALTER PROCEDURE [dbo].[TestDocs_Insert]
  @Type_Id   Char(1),
  @DateTime  DateTime,
  @NewNumber VarChar(50) = NULL OUT -- Исключительно OUTPUT-параметр!
AS
	INSERT INTO [dbo].[TestDocs]
		([Type_Id], [DateTime], [Number], [spid])
	VALUES
		(@Type_Id, @DateTime, '', @@SPID);

	DECLARE @id INT = @@IDENTITY;

	SET @NewNumber = (
		SELECT TOP 1 
			CONCAT(FORMAT(@DateTime, 'yyyyMMdd'), '/', @Type_Id, '-', CAST(dr.RN AS VARCHAR(16)))
			FROM
				(
					SELECT 
						ROW_NUMBER() OVER(PARTITION BY CONVERT(date, [DateTime]), [Type_Id] ORDER BY [Id]) RN,
						Id
					FROM
						[dbo].[TestDocs]
					WHERE
						CONVERT(date, [DateTime])=CONVERT(date, @DateTime) AND [Type_Id]=@Type_Id
				) dr
		WHERE dr.Id=@id)
	
    UPDATE [dbo].[TestDocs] SET [Number]=@NewNumber WHERE Id=@id

	RETURN (1)
GO

-- 2:50

SELECT
    Type_Id, CONVERT(date, [DateTime]), Number, COUNT(*)
FROM 
    [dbo].[TestDocs]
GROUP BY
    Type_Id, CONVERT(date, [DateTime]), Number
HAVING
    COUNT(*)>1

-- полезный индекс, но нарушающий условие (добавление поля)
ALTER TABLE [dbo].[TestDocs] ADD [Date] AS CONVERT(date, [DateTime]);

CREATE INDEX IDX_TestDocs ON [dbo].[TestDocs]
(
    [Date] ASC, 
    [Type_Id] ASC,
    [Id] ASC
)
