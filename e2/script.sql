-- если отдел без людей вполне себе отдел

SELECT
	d.[Name], COUNT(p.Id)
FROM
	[Departs] d LEFT OUTER JOIN [Persons] p ON p.[Depart_Id]=d.[Id]
GROUP BY
	d.[Name]



-- если отдел без людей не считается отделом

SELECT
	d.[Name], COUNT(*)
FROM
	[Departs] d JOIN [Persons] p ON p.[Depart_Id]=d.[Id]
GROUP BY
	d.[Name]