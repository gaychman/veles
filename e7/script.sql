-- таблица отличается от той, что в условии - переименована в Departs7
SET NOCOUNT ON
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Departs7]
(
  [Id]        Int           NOT NULL IDENTITY(1,1),
  [Parent_Id] Int               NULL REFERENCES [Departs7] ([Id]),
  [Name]      NVarChar(100) NOT NULL,
  PRIMARY KEY CLUSTERED([Id])
)
GO

CREATE INDEX IDX_Departs7_PID ON [Departs7]
(
	Parent_Id ASC
)
-- по плану выполнения бесполезен?

-- CTE и рекурсия
DECLARE @WithOutDepart_Id Int = 2;

-- Выдать все подразделения, кроме подразделения @WithOutDepart_Id и всех его потомков
WITH cte_departs AS
(
	SELECT dr.* FROM [Departs7] dr WHERE dr.[Id]<>@WithOutDepart_Id AND dr.[Parent_Id] IS NULL
	UNION ALL
	SELECT dc.* FROM [Departs7] dc INNER JOIN cte_departs dp ON dp.Id=dc.Parent_Id WHERE dp.Id<>@WithOutDepart_Id
)
SELECT *
FROM cte_departs
