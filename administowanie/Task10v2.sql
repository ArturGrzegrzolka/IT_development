USE [zadanie_new]
GO

/****** Object:  UserDefinedFunction [dbo].[Task10.v2]    Script Date: 11.02.2023 14:34:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION[dbo].[Task10.v2]
(	
	@oddzia�Id INT
)
RETURNS TABLE 
AS
RETURN 
(
	--��czny czas drukowania zleconych oddzia�owi element�w w minutach
	select  o.id as oddzia�, SUM(z.ilosc * 15) as czas_drukowania_zleconych_elementow_oddzialowi
	from dbo.zlecenia as z
	left join dbo.zlecenie_realizacja as zr on  zr.zlecenie_id = z.id 
	left join dbo.oddzial as o on o.id = zr.oddzial_id
	where o.id = @oddzia�Id
	group by o.id, z.ilosc
)
GO


