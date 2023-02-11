use zadanie_new
go


CREATE FUNCTION[dbo].[Task09]
(	
	@oddzialId INT
)
RETURNS TABLE 
AS
RETURN 
(
	select oddzial_id, count(*) ilosc_zlecen_do_realizacji
	from zadanie_new.dbo.zlecenie_realizacja 
	where zlecenie_status_id <>5
	group by oddzial_id
)
GO