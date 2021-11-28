SELECT
	p.[Name], d.[Name]
FROM
	[Persons] p JOIN [Departs] d ON p.[Depart_Id]=d.[Id]