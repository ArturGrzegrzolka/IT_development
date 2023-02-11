USE [zadanie_new]
GO

/****** Object:  UserDefinedFunction [dbo].[Task11.v1]    Script Date: 11.02.2023 14:34:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create FUNCTION[dbo].[Task11.v1]
(	
	@oddzia�Id INT
)
RETURNS TABLE 
AS
RETURN 
(
	--je�li u�ytkownik poda oddzia� to funkcja zwr�ci true lub false czy si� wyrobi w 36 h
	select  o.id as oddzia�,
	CAST(CASE WHEN DATEPART(HH,(DATEADD(MI, SUM(z.ilosc * 15),'0:00:00'))) > 36 then 0 ELSE 1 end as BIT) as czy_moze_byc_zrealizowane
	from dbo.zlecenia as z
	left join dbo.zlecenie_realizacja as zr on  zr.zlecenie_id = z.id 
	left join dbo.oddzial as o on o.id = zr.oddzial_id
	where o.id = @oddzia�Id
	group by o.id, z.ilosc
)
GO


