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
			CONCAT(FORMAT([DateTime], 'yyyyMMdd'), '/', @Type_Id, '-', CAST(dr.RN AS VARCHAR(16)))
			FROM
				[dbo].[TestDocs] d JOIN (
					SELECT 
						ROW_NUMBER() OVER(PARTITION BY CONVERT(date, [DateTime]), [Type_Id] ORDER BY [Id]) RN,
						Id
					FROM
					[dbo].[TestDocs]
				) dr ON dr.Id=d.Id
		WHERE d.Id=@id)
	
	RETURN (1)
GO