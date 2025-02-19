USE [zadanie]
GO
/****** Object:  UserDefinedFunction [dbo].[getMinutesFromDates]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Create function getMinutesFromDates (@data1 datetime, @data2 datetime) returns int
CREATE function [dbo].[getMinutesFromDates] (@data1 datetime, @data2 datetime) returns int
as
begin

declare @result int;
declare @dayOfWeek1 int;
declare @dayOfWeek2 int;
declare @pom int; -- pomocnicza
declare @pom_date1 datetime; -- pomocnicza
declare @pom_result nvarchar(max)
declare @weeks int 

--	set @data1 = convert(datetime,'2022-11-19 12:54:12', 102)
--	set @data2 = convert(datetime,'2022-11-30 15:54:12', 102)

	set @dayOfWeek1 = datepart(WEEKDAY, @data1); -- odczytanie dnia tygodnia z daty1
--	if (@dayOfWeek1=7 and datepart(hour, @data1)>=6) -- jesli sobota i po 6.00 to przesuwamy sie z data na koniec dnia
--	  begin
--		set @pom = Datediff(n, @data1, (convert(datetime,	convert(varchar(4), datepart(YYYY, @data1)) + '-'+
--															convert(varchar(2), datepart(mm, @data1))+ '-'+
--															convert(varchar(2), datepart(dd, @data1))+' 23:59:59', 102) ));
--		set @pom = @pom + 30*60; -- przesywamy sie na 6.00 w poniedzialek
--	  end;
--	if (@dayOfWeek1=2 and datepart(hour, @data1)<6) -- jeli poniedzialek przed 6.00
--		begin
--		set @pom = Datediff(n, @data1, (convert(datetime,	convert(varchar(4), datepart(YYYY, @data1)) + '-'+
--															convert(varchar(2), datepart(mm, @data1))+ '-'+
--															convert(varchar(2), datepart(dd, @data1))+' 06:00:00', 102) ));
--		end;
--	if (@dayOfWeek1=1 ) -- jeli niedziela
--		begin
--		set @pom = Datediff(n, @data1, (convert(datetime,	convert(varchar(4), datepart(YYYY, @data1)) + '-'+
--															convert(varchar(2), datepart(mm, @data1))+ '-'+
--															convert(varchar(2), datepart(dd, @data1))+' 23:59:59', 102) ));
--		set @pom = @pom + 6*60; -- przesywamy sie na 6.00 w poniedzialek
--		end;
--
--	set @dayOfWeek2 = datepart(weekday, @data2);	
--	if (@dayOfWeek1 = 1 or @dayOfWeek1=7 and datepart(hour, @data1)>=6 or @dayOfWeek1=7 and datepart(hour, @data1)<6 )
--	set @data1

-- drugi wariant - upraszczajacy
	if 	(@dayOfWeek1=7 and datepart(hour, @data1)>=6) or
		(@dayOfWeek1=1 ) or
		(@dayOfWeek1=2 and datepart(hour, @data1)<6)
		begin
			if (@dayOfWeek1=7 and datepart(hour, @data1)>=6) -- jesli sobota i po 6.00 to przesuwamy sie z data na koniec dnia
			  begin
				set @data1 = dateadd (dd, 2, @data1);
			  end
			if (@dayOfWeek1=1 ) -- -- jeli niedziela
			  begin
				set @data1 = dateadd (dd, 1, @data1);
			  end
			set @data1 = convert(datetime,	convert(varchar(4), datepart(YYYY, @data1)) + '-'+
																convert(varchar(2), datepart(mm, @data1))+ '-'+
																convert(varchar(2), datepart(dd, @data1))+' 06:00:00', 102);
		end
	
	set @dayOfWeek2 = datepart(WEEKDAY, @data2); -- odczytanie dnia tygodnia z daty2
	if 	(@dayOfWeek2=7 and datepart(hour, @data2)>=6) or
		(@dayOfWeek2=1 ) or
		(@dayOfWeek2=2 and datepart(hour, @data2)<6)
		begin
			if (@dayOfWeek2=1 ) -- jeli niedziela
			  begin
				set @data2 = dateadd (dd, -1, @data2);
			  end
			if (@dayOfWeek2=2 and datepart(hour, @data2)<6) -- jeli poniedzialek
			  begin
				set @data2 = dateadd (dd, -2, @data2);
			  end
			set @data2 = convert(datetime,	convert(varchar(4), datepart(YYYY, @data2)) + '-'+
																convert(varchar(2), datepart(mm, @data2))+ '-'+
																convert(varchar(2), datepart(dd, @data2))+' 06:00:00', 102);
		end

		set @result = datediff(n, @data1, @data2);
			--if (@result /10080) -- ilosc minut w tygodniu

		
		set @weeks = DATEPART(ww,@data2)-  DATEPART(ww,@data1)
		set @result = @result - (@weeks * 2880) -- jesli weekend wystepuje w czasie naprawy.

return @result
end;
GO
/****** Object:  UserDefinedFunction [dbo].[getShiftsFromDates]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Create function getMinutesFromDates (@data1 datetime, @data2 datetime) returns int
CREATE function [dbo].[getShiftsFromDates] (@data1 datetime, @data2 datetime) returns int
as
begin

declare @result int;
declare @dayOfWeek1 int;
declare @dayOfWeek2 int;
declare @pom int; -- pomocnicza
declare @pom_date1 datetime; -- pomocnicza
declare @pom_result nvarchar(max)
declare @weeks int 

	set @dayOfWeek1 = datepart(WEEKDAY, @data1); -- odczytanie dnia tygodnia z daty1

-- drugi wariant - upraszczajacy
	if 	(@dayOfWeek1=7 and datepart(hour, @data1)>=6) or
		(@dayOfWeek1=1 ) or
		(@dayOfWeek1=2 and datepart(hour, @data1)<6)
		begin
			if (@dayOfWeek1=7 and datepart(hour, @data1)>=6) -- jesli sobota i po 6.00 to przesuwamy sie z data na koniec dnia
			  begin
				set @data1 = dateadd (dd, 2, @data1);
			  end
			if (@dayOfWeek1=1 ) -- -- jeli niedziela
			  begin
				set @data1 = dateadd (dd, 1, @data1);
			  end
			set @data1 = convert(datetime,	convert(varchar(4), datepart(YYYY, @data1)) + '-'+
																convert(varchar(2), datepart(mm, @data1))+ '-'+
																convert(varchar(2), datepart(dd, @data1))+' 06:00:00', 102);
		end
	
	set @dayOfWeek2 = datepart(WEEKDAY, @data2); -- odczytanie dnia tygodnia z daty2
	if 	(@dayOfWeek2=7 and datepart(hour, @data2)>=6) or
		(@dayOfWeek2=1 ) or
		(@dayOfWeek2=2 and datepart(hour, @data2)<6)
		begin
			if (@dayOfWeek2=1 ) -- jeli niedziela
			  begin
				set @data2 = dateadd (dd, -1, @data2);
			  end
			if (@dayOfWeek2=2 and datepart(hour, @data2)<6) -- jeli poniedzialek
			  begin
				set @data2 = dateadd (dd, -2, @data2);
			  end
			set @data2 = convert(datetime,	convert(varchar(4), datepart(YYYY, @data2)) + '-'+
																convert(varchar(2), datepart(mm, @data2))+ '-'+
																convert(varchar(2), datepart(dd, @data2))+' 06:00:00', 102);
		end

		DECLARE @jumpdatetime datetime = @data1
		DECLARE @shift_number int = 0
		WHILE @jumpdatetime < @data2
		BEGIN
		--sobota 7
		--niedziela 1
		--poniedziałek 2
		--datepart(hour, @data1)
		/*if kiedy weekend*/
			IF (datepart(WEEKDAY, @jumpdatetime)=7 and datepart(hour, @jumpdatetime)>=6) OR (datepart(WEEKDAY, @jumpdatetime)=1) OR
			(datepart(WEEKDAY, @jumpdatetime)=2 and datepart(hour, @jumpdatetime)<6)
			BEGIN
				SET @shift_number = @shift_number
			END
			ELSE 
				SET @shift_number = @shift_number + 1
			
			SET @jumpdatetime = dateadd(hour, 8, @jumpdatetime)
		END

		SET @shift_number = CASE WHEN zadanie.dbo.shift_no(@jumpdatetime) = zadanie.dbo.shift_no(@data2) THEN @shift_number + 1 ELSE @shift_number END


return @shift_number
end;
GO
/****** Object:  UserDefinedFunction [dbo].[shift_no]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[shift_no]
(
	-- Add the parameters for the function here
	@datetime datetime
)
RETURNS int
AS
BEGIN
	
	DECLARE @shift_no int
	SET @shift_no = CASE WHEN datepart(hour, @datetime) < 6 THEN 3
	                     WHEN datepart(hour, @datetime) < 14 tHEN 1
						 WHEN datepart(hour, @datetime) > 22 tHEN 3
						 WHEN @datetime is null then null
						 ELSE 2
						 END

	RETURN @shift_no

END
GO
/****** Object:  UserDefinedFunction [dbo].[unit_with_most_defects]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[unit_with_most_defects]
(	
	@data1 datetime,
	@data2 datetime
)
RETURNS int 
AS
BEGIN

DECLARE @temp TABLE (oddzial int, count_no int)

INSERT INTO @temp
SELECT * from zadanie.dbo.[defects_per_unit] (@data1,@data2)
DECLARE @oddzial_id int =
(SELECT TOP 1 oddzial
fROM @temp
ORDER BY count_no DESC)

RETURN @oddzial_id
END
GO
/****** Object:  Table [dbo].[usterka]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usterka](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_awaria] [int] NULL,
	[opis] [varchar](1000) NULL,
	[data_zgloszenia] [datetime] NULL,
	[poczatek_naprawy] [datetime] NULL,
	[koniec_naprawy] [datetime] NULL,
	[urzadzenie_id] [int] NOT NULL,
	[status_id] [int] NULL,
 CONSTRAINT [PK__usterka__3213E83FE385BEAB] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getmalfunction]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getmalfunction]
(	
	@data1 datetime,
	@data2 datetime,
	@deviceid int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT id, id_awaria, 
		iif (poczatek_naprawy < @data1, @data1, poczatek_naprawy) poczatek_naprawy,
		iif (koniec_naprawy > @data2 or koniec_naprawy is null, @data2, koniec_naprawy) koniec_naprawy
	from dbo.usterka where urzadzenie_id=@deviceid 
		--and (usterka.poczatek_naprawy >= @data1 and (usterka.koniec_naprawy <= @data2 or usterka.koniec_naprawy is null))
		and (
				(usterka.koniec_naprawy between @data1 and @data2 or usterka.koniec_naprawy is null)
				or (usterka.poczatek_naprawy between @data1 and @data2 and (usterka.koniec_naprawy is null or usterka.koniec_naprawy >= @data2))
				or (usterka.poczatek_naprawy<=@data1 and (usterka.koniec_naprawy is null or usterka.koniec_naprawy >= @data2))
			)
)

GO
/****** Object:  Table [dbo].[urzadzenie]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[urzadzenie](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[oddzial_id] [int] NULL,
	[nazwa] [varchar](255) NULL,
	[status] [int] NULL,
	[nr_seryjny] [varchar](100) NULL,
 CONSTRAINT [PK__urzadzen__3213E83F5F8B800F] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[defects_per_unit]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[defects_per_unit]
(	
	@data1 datetime,
	@data2 datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT TOP 1 urz.oddzial_id,count(ust.id) as count_no
FROM zadanie.dbo.usterka ust
INNER JOIN zadanie.dbo.urzadzenie urz
ON ust.urzadzenie_id=urz.id
WHERE ust.data_zgloszenia between @data1 and @data2
group by urz.oddzial_id

)

GO
/****** Object:  View [dbo].[statuses_fraction]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[statuses_fraction] as
SELECT x.status
      ,CONVERT(float, count_case) / CONVERT(float, all_rows) AS fraction
FROM (
      SELECT a.status
            ,count(1) as count_case
            ,b.all_rows
      FROM zadanie.dbo.urzadzenie a
      LEFT JOIN (
                 SELECT count(1) as all_rows
                 From zadanie.dbo.urzadzenie
                ) b
      ON 1 = 1
      group by a.status,b.all_rows
     ) x
GO
/****** Object:  Table [dbo].[zlecenia]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zlecenia](
	[id_zlecenia] [int] IDENTITY(1,1) NOT NULL,
	[numer_zlecenia] [varchar](255) NULL,
	[data_zlecenia] [datetime] NULL,
	[oddzial_id] [int] NULL,
 CONSTRAINT [PK__zlecenia__3213E83F808F5DE0] PRIMARY KEY CLUSTERED 
(
	[id_zlecenia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zlecenie_element_status]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zlecenie_element_status](
	[id_zlecenie_status] [int] IDENTITY(1,1) NOT NULL,
	[zlecenie_status] [varchar](50) NULL,
 CONSTRAINT [PK_zlecenie_status] PRIMARY KEY CLUSTERED 
(
	[id_zlecenie_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zlecenie_element]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zlecenie_element](
	[id_zlecenie_element] [int] IDENTITY(1,1) NOT NULL,
	[id_zlecenie] [int] NOT NULL,
	[id_type] [int] NOT NULL,
	[id_status] [int] NOT NULL,
	[id_urzadzenia] [int] NULL,
	[realization_start] [datetime] NULL,
	[realization_end] [datetime] NULL,
 CONSTRAINT [PK_zlecenie_element] PRIMARY KEY CLUSTERED 
(
	[id_zlecenie_element] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_nieskonczone_zlecenia]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v_nieskonczone_zlecenia] AS 
SELECT a.oddzial_id, count(DISTINCT numer_zlecenia) as nieskonczone_zlecenia
FROM zadanie.dbo.zlecenia a
INNER JOIN zadanie.dbo.zlecenie_element b
ON id_zlecenia=b.id_zlecenie
INNER JOIN zadanie.dbo.zlecenie_element_status c
ON b.id_status=c.id_zlecenie_status
WHERE c.zlecenie_Status in ('To Do','In Progress')
group by a.oddzial_id
GO
/****** Object:  Table [dbo].[element_typ]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[element_typ](
	[id_typ] [int] IDENTITY(1,1) NOT NULL,
	[typ_name] [nvarchar](255) NOT NULL,
	[typ_time_min] [int] NOT NULL,
 CONSTRAINT [PK_element_typ] PRIMARY KEY CLUSTERED 
(
	[id_typ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_elementy_do_realizacji_aggr]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v_elementy_do_realizacji_aggr] AS 
SELECT a.oddzial_id,count(id_zlecenie_element) liczba_Elementow_do_realizacji,sum(typ_time_min) czas_drukowania_elementow_do_realizacji_in_min
FROM zadanie.dbo.zlecenia a
INNER JOIN zadanie.dbo.zlecenie_element b
ON id_zlecenia=b.id_zlecenie
INNER JOIN zadanie.dbo.zlecenie_element_status c
ON b.id_status=c.id_zlecenie_status
INNER JOIN element_typ d
ON b.id_type = d.id_typ
WHERE c.zlecenie_Status in ('To Do')
group by a.oddzial_id
GO
/****** Object:  Table [dbo].[oddzial]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oddzial](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nazwa] [varchar](255) NULL,
	[kod_oddzialu] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pracownik]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pracownik](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[oddzial_id] [int] NULL,
	[nazwa] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[urzadzenie_status]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[urzadzenie_status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[status] [int] NULL,
	[opis] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usterka_status]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usterka_status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[kod] [int] NULL,
	[opis] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[element_typ] ON 

INSERT [dbo].[element_typ] ([id_typ], [typ_name], [typ_time_min]) VALUES (1, N'Typ1', 5)
INSERT [dbo].[element_typ] ([id_typ], [typ_name], [typ_time_min]) VALUES (2, N'Typ2', 10)
INSERT [dbo].[element_typ] ([id_typ], [typ_name], [typ_time_min]) VALUES (3, N'Typ3', 15)
SET IDENTITY_INSERT [dbo].[element_typ] OFF
GO
SET IDENTITY_INSERT [dbo].[oddzial] ON 

INSERT [dbo].[oddzial] ([id], [nazwa], [kod_oddzialu]) VALUES (1, N'Drukarki 3d', N'DR3D')
INSERT [dbo].[oddzial] ([id], [nazwa], [kod_oddzialu]) VALUES (2, N'Wtryskarki 3d', N'WT3D')
SET IDENTITY_INSERT [dbo].[oddzial] OFF
GO
SET IDENTITY_INSERT [dbo].[pracownik] ON 

INSERT [dbo].[pracownik] ([id], [oddzial_id], [nazwa]) VALUES (1, 1, N'Adam Kowalski')
INSERT [dbo].[pracownik] ([id], [oddzial_id], [nazwa]) VALUES (2, 1, N'Tomasz Testowy')
INSERT [dbo].[pracownik] ([id], [oddzial_id], [nazwa]) VALUES (3, 2, N'Jan Berg')
INSERT [dbo].[pracownik] ([id], [oddzial_id], [nazwa]) VALUES (4, 2, N'Piotr Drugi')
SET IDENTITY_INSERT [dbo].[pracownik] OFF
GO
SET IDENTITY_INSERT [dbo].[urzadzenie] ON 

INSERT [dbo].[urzadzenie] ([id], [oddzial_id], [nazwa], [status], [nr_seryjny]) VALUES (1, 1, N'Drukarka XYZ 1', 1, N'1234AB')
INSERT [dbo].[urzadzenie] ([id], [oddzial_id], [nazwa], [status], [nr_seryjny]) VALUES (2, 1, N'Drukarka XYZ 2', 1, N'3456AC')
INSERT [dbo].[urzadzenie] ([id], [oddzial_id], [nazwa], [status], [nr_seryjny]) VALUES (3, 2, N'Wtryskarka XYZ 1', 1, N'2345CD')
INSERT [dbo].[urzadzenie] ([id], [oddzial_id], [nazwa], [status], [nr_seryjny]) VALUES (4, 2, N'Wtryskarka XYZ 2', 1, N'4567DE')
SET IDENTITY_INSERT [dbo].[urzadzenie] OFF
GO
SET IDENTITY_INSERT [dbo].[urzadzenie_status] ON 

INSERT [dbo].[urzadzenie_status] ([id], [status], [opis]) VALUES (1, 0, N'Active')
INSERT [dbo].[urzadzenie_status] ([id], [status], [opis]) VALUES (2, 1, N'Inactive')
SET IDENTITY_INSERT [dbo].[urzadzenie_status] OFF
GO
SET IDENTITY_INSERT [dbo].[usterka] ON 

INSERT [dbo].[usterka] ([id], [id_awaria], [opis], [data_zgloszenia], [poczatek_naprawy], [koniec_naprawy], [urzadzenie_id], [status_id]) VALUES (1, 1, NULL, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2022-12-10T00:00:00.000' AS DateTime), 1, 1)
INSERT [dbo].[usterka] ([id], [id_awaria], [opis], [data_zgloszenia], [poczatek_naprawy], [koniec_naprawy], [urzadzenie_id], [status_id]) VALUES (4, 1, NULL, CAST(N'2022-12-02T00:00:00.000' AS DateTime), CAST(N'2022-12-02T00:00:00.000' AS DateTime), CAST(N'2022-12-08T00:00:00.000' AS DateTime), 1, 1)
INSERT [dbo].[usterka] ([id], [id_awaria], [opis], [data_zgloszenia], [poczatek_naprawy], [koniec_naprawy], [urzadzenie_id], [status_id]) VALUES (5, 1, NULL, CAST(N'2022-12-02T00:00:00.000' AS DateTime), CAST(N'2022-12-02T00:00:00.000' AS DateTime), CAST(N'2022-12-12T23:59:59.000' AS DateTime), 1, 1)
INSERT [dbo].[usterka] ([id], [id_awaria], [opis], [data_zgloszenia], [poczatek_naprawy], [koniec_naprawy], [urzadzenie_id], [status_id]) VALUES (6, 1, NULL, CAST(N'2022-12-14T00:00:00.000' AS DateTime), CAST(N'2022-12-14T00:00:00.000' AS DateTime), CAST(N'2022-12-15T00:00:00.000' AS DateTime), 1, 1)
INSERT [dbo].[usterka] ([id], [id_awaria], [opis], [data_zgloszenia], [poczatek_naprawy], [koniec_naprawy], [urzadzenie_id], [status_id]) VALUES (7, 1, NULL, CAST(N'2022-12-15T00:00:00.000' AS DateTime), CAST(N'2022-12-15T00:00:00.000' AS DateTime), NULL, 1, 1)
INSERT [dbo].[usterka] ([id], [id_awaria], [opis], [data_zgloszenia], [poczatek_naprawy], [koniec_naprawy], [urzadzenie_id], [status_id]) VALUES (9, 1, NULL, CAST(N'2022-11-01T00:00:00.000' AS DateTime), CAST(N'2022-11-01T00:00:00.000' AS DateTime), CAST(N'2022-11-05T00:00:00.000' AS DateTime), 1, 3)
INSERT [dbo].[usterka] ([id], [id_awaria], [opis], [data_zgloszenia], [poczatek_naprawy], [koniec_naprawy], [urzadzenie_id], [status_id]) VALUES (11, 1, NULL, CAST(N'2022-12-16T00:00:00.000' AS DateTime), CAST(N'2022-12-16T00:00:00.000' AS DateTime), CAST(N'2022-12-17T00:00:00.000' AS DateTime), 1, 1)
SET IDENTITY_INSERT [dbo].[usterka] OFF
GO
SET IDENTITY_INSERT [dbo].[usterka_status] ON 

INSERT [dbo].[usterka_status] ([id], [kod], [opis]) VALUES (1, 0, N'urządzenie działa poprawnie')
INSERT [dbo].[usterka_status] ([id], [kod], [opis]) VALUES (2, 1, N'przekazanie informacji do centrali')
INSERT [dbo].[usterka_status] ([id], [kod], [opis]) VALUES (3, 2, N'diagnoza przyczyny awarii')
INSERT [dbo].[usterka_status] ([id], [kod], [opis]) VALUES (4, 3, N'rozpoczęcie naprawy')
INSERT [dbo].[usterka_status] ([id], [kod], [opis]) VALUES (5, 4, N'testy')
INSERT [dbo].[usterka_status] ([id], [kod], [opis]) VALUES (6, 5, N'przywrócenie do etapu działania produkcyjnego')
INSERT [dbo].[usterka_status] ([id], [kod], [opis]) VALUES (7, 6, N'urządzenia nie udaje się naprawić podlega kasacji')
SET IDENTITY_INSERT [dbo].[usterka_status] OFF
GO
SET IDENTITY_INSERT [dbo].[zlecenia] ON 

INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (1, N'ZLEC1', CAST(N'2010-01-01T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (2, N'ZLEC2', CAST(N'2010-01-02T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (3, N'ZLEC3', CAST(N'2010-01-03T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (4, N'ZLEC4', CAST(N'2010-01-04T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (5, N'ZLEC5', CAST(N'2010-01-05T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (6, N'ZLEC6', CAST(N'2010-01-06T00:00:00.000' AS DateTime), 2)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (7, N'ZLEC7', CAST(N'2010-01-07T00:00:00.000' AS DateTime), 2)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (8, N'ZLEC8', CAST(N'2010-01-08T00:00:00.000' AS DateTime), 2)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (9, N'ZLEC9', CAST(N'2010-01-09T00:00:00.000' AS DateTime), 2)
INSERT [dbo].[zlecenia] ([id_zlecenia], [numer_zlecenia], [data_zlecenia], [oddzial_id]) VALUES (10, N'ZLEC10', CAST(N'2010-01-09T00:00:00.000' AS DateTime), 2)
SET IDENTITY_INSERT [dbo].[zlecenia] OFF
GO
SET IDENTITY_INSERT [dbo].[zlecenie_element] ON 

INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (1, 1, 1, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (2, 1, 2, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (3, 2, 3, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (4, 2, 1, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (5, 3, 2, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (6, 3, 3, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (7, 4, 1, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (8, 4, 2, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (9, 5, 3, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (10, 5, 1, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (11, 6, 2, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (12, 6, 3, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (13, 7, 1, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (14, 7, 2, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (15, 8, 3, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (16, 8, 1, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (17, 9, 2, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (18, 9, 3, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (19, 10, 1, 1, NULL, NULL, NULL)
INSERT [dbo].[zlecenie_element] ([id_zlecenie_element], [id_zlecenie], [id_type], [id_status], [id_urzadzenia], [realization_start], [realization_end]) VALUES (20, 10, 2, 1, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[zlecenie_element] OFF
GO
SET IDENTITY_INSERT [dbo].[zlecenie_element_status] ON 

INSERT [dbo].[zlecenie_element_status] ([id_zlecenie_status], [zlecenie_status]) VALUES (1, N'To Do')
INSERT [dbo].[zlecenie_element_status] ([id_zlecenie_status], [zlecenie_status]) VALUES (2, N'In Progress')
INSERT [dbo].[zlecenie_element_status] ([id_zlecenie_status], [zlecenie_status]) VALUES (3, N'Done')
SET IDENTITY_INSERT [dbo].[zlecenie_element_status] OFF
GO
ALTER TABLE [dbo].[pracownik]  WITH CHECK ADD  CONSTRAINT [FK_pracownik_oddzial] FOREIGN KEY([oddzial_id])
REFERENCES [dbo].[oddzial] ([id])
GO
ALTER TABLE [dbo].[pracownik] CHECK CONSTRAINT [FK_pracownik_oddzial]
GO
ALTER TABLE [dbo].[urzadzenie]  WITH CHECK ADD  CONSTRAINT [FK_urzadzenie_oddzial] FOREIGN KEY([oddzial_id])
REFERENCES [dbo].[oddzial] ([id])
GO
ALTER TABLE [dbo].[urzadzenie] CHECK CONSTRAINT [FK_urzadzenie_oddzial]
GO
ALTER TABLE [dbo].[urzadzenie]  WITH CHECK ADD  CONSTRAINT [FK_urzadzenie_urzadzenie_status] FOREIGN KEY([status])
REFERENCES [dbo].[urzadzenie_status] ([id])
GO
ALTER TABLE [dbo].[urzadzenie] CHECK CONSTRAINT [FK_urzadzenie_urzadzenie_status]
GO
ALTER TABLE [dbo].[usterka]  WITH CHECK ADD  CONSTRAINT [FK_usterka_urzadzenie] FOREIGN KEY([urzadzenie_id])
REFERENCES [dbo].[urzadzenie] ([id])
GO
ALTER TABLE [dbo].[usterka] CHECK CONSTRAINT [FK_usterka_urzadzenie]
GO
ALTER TABLE [dbo].[usterka]  WITH CHECK ADD  CONSTRAINT [FK_usterka_usterka_status] FOREIGN KEY([status_id])
REFERENCES [dbo].[usterka_status] ([id])
GO
ALTER TABLE [dbo].[usterka] CHECK CONSTRAINT [FK_usterka_usterka_status]
GO
ALTER TABLE [dbo].[zlecenia]  WITH CHECK ADD  CONSTRAINT [FK_zlecenia_oddzial] FOREIGN KEY([oddzial_id])
REFERENCES [dbo].[oddzial] ([id])
GO
ALTER TABLE [dbo].[zlecenia] CHECK CONSTRAINT [FK_zlecenia_oddzial]
GO
ALTER TABLE [dbo].[zlecenie_element]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_element_element_typ] FOREIGN KEY([id_type])
REFERENCES [dbo].[element_typ] ([id_typ])
GO
ALTER TABLE [dbo].[zlecenie_element] CHECK CONSTRAINT [FK_zlecenie_element_element_typ]
GO
ALTER TABLE [dbo].[zlecenie_element]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_element_urzadzenie] FOREIGN KEY([id_urzadzenia])
REFERENCES [dbo].[urzadzenie] ([id])
GO
ALTER TABLE [dbo].[zlecenie_element] CHECK CONSTRAINT [FK_zlecenie_element_urzadzenie]
GO
ALTER TABLE [dbo].[zlecenie_element]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_element_zlecenia] FOREIGN KEY([id_zlecenie])
REFERENCES [dbo].[zlecenia] ([id_zlecenia])
GO
ALTER TABLE [dbo].[zlecenie_element] CHECK CONSTRAINT [FK_zlecenie_element_zlecenia]
GO
ALTER TABLE [dbo].[zlecenie_element]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_element_zlecenie_element_status] FOREIGN KEY([id_status])
REFERENCES [dbo].[zlecenie_element_status] ([id_zlecenie_status])
GO
ALTER TABLE [dbo].[zlecenie_element] CHECK CONSTRAINT [FK_zlecenie_element_zlecenie_element_status]
GO
/****** Object:  StoredProcedure [dbo].[getAgregateIntervals]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getAgregateIntervals]
(	@data1 datetime,
	@data2 datetime,
	@deviceid int
)
as
begin
DECLARE @c1_id int,
	@c1_id_awaria int,
	@c1_poczatek_naprawy datetime,
	@c1_koniec_naprawy datetime,
	@c2_id int,
	@c2_id_awaria int,
	@c2_poczatek_naprawy datetime,
	@c2_koniec_naprawy datetime

	declare
	@tmp_table table (id int, id_awaria int, poczatek_naprawy datetime, koniec_naprawy datetime)
	declare
	@tmp_table_base table (id int, id_awaria int, poczatek_naprawy datetime, koniec_naprawy datetime)
	
	-- Add the SELECT statement with parameter references here
	INSERT INTO @tmp_table_base
	select * from getmalfunction(@data1, @data2, @deviceid);
	
	DECLARE @count1 int = 0
	DECLARE @count2 int = 1
	WHILE (@count1 <> @count2)
	BEGIN
		DELETE @tmp_table
		/*temporary*/
		--SELECT * from @tmp_table_base
		/*temporary*/
		declare c1 cursor for
			select * from @tmp_table_base order by id, koniec_naprawy;
		open c1
			fetch next from c1 into @c1_id, @c1_id_awaria, @c1_poczatek_naprawy, @c1_koniec_naprawy /*przechodzi po wszystkich wierszach*/
			WHILE @@FETCH_STATUS =0
			begin
				declare c2 cursor for
					select * from @tmp_table_base where id > @c1_id order by poczatek_naprawy, koniec_naprawy /*wszystkie kolejne wiersze z intervali*/;
					open c2
					fetch next from c2 into @c2_id, @c2_id_awaria, @c2_poczatek_naprawy, @c2_koniec_naprawy
					WHILE @@FETCH_STATUS = 0
					BEGIN
					if (@c2_poczatek_naprawy between @c1_poczatek_naprawy and @c1_koniec_naprawy) 
					   OR (@c1_poczatek_naprawy between @c2_poczatek_naprawy and @c2_koniec_naprawy)
					insert into @tmp_table (id, id_awaria, poczatek_naprawy, koniec_naprawy) values 
						(@c1_id, @c1_id_awaria, IIF(@c1_poczatek_naprawy < @c2_poczatek_naprawy, @c1_poczatek_naprawy, @c2_poczatek_naprawy)
						, IIF(@c1_koniec_naprawy > @c2_koniec_naprawy, @c1_koniec_naprawy, @c2_koniec_naprawy))
					fetch next from c2 into @c2_id, @c2_id_awaria, @c2_poczatek_naprawy, @c2_koniec_naprawy
					--PRINT('Petla')
					end
				close c2
				deallocate c2
				fetch next from c1 into @c1_id, @c1_id_awaria, @c1_poczatek_naprawy, @c1_koniec_naprawy
			end
		close c1
		deallocate c1
		SET @count1 = (SELECT count(1) FROM @tmp_table_base)
		SET @count2 = (SELECT count(1) FROM @tmp_table)
		--PRINT('count1:' + CONVERT(varchar(2),@count1)+'; count2:'+CONVERT(varchar(2),@count2))
		IF @count2 = 0
		BEGIN
		SET @count1 = @count2
		END
		
		IF (@count1 <> @count2 and @count2 <> 0)
		BEGIN
		DELETE FROM @tmp_table_base
		INSERT INTO @tmp_table_base
		SELECT * FROM @tmp_table
		END
		

	END

	select DISTINCT * from @tmp_table_base

end
GO
/****** Object:  StoredProcedure [dbo].[Number_of_shifts_not_working]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Number_of_shifts_not_working]
(	@data1 datetime,
	@data2 datetime,
	@deviceid int
)
as
begin
DECLARE @t table (id int, id_awaria int, poczatek_naprawy datetime, koniec_naprawy datetime)
INSERT @t
EXEC zadanie.[dbo].[getAgregateIntervals] @data1, @data2, @deviceid

SELECT id,poczatek_naprawy, koniec_naprawy, zadanie.dbo.getshiftsfromdates(poczatek_naprawy, koniec_naprawy) Number_of_shifts
From @t


end
GO
/****** Object:  StoredProcedure [dbo].[SumOfAllInactiveMinutes]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[SumOfAllInactiveMinutes] 
(
	-- Add the parameters for the function here
	@date_from datetime,
	@date_to datetime
)
AS
BEGIN
	
DECLARE @overal_sum int = 0
DECLARE @individual_sum int = 0
--DECLARE @date_from datetime = '2022-12-07'
--DECLARE @date_to datetime = '2022-12-16'

DECLARE kursor CURSOR FOR SELECT DISTINCT urzadzenie_id from zadanie.dbo.usterka
DECLARE @id int
OPEN kursor 
FETCH NEXT FROM kursor into @id
WHILE @@FETCH_STATUS = 0
BEGIN

--SELECT @id, @date_from, @date_to
--exec zadanie.dbo.SumOfInactiveMinutes @date_from, @date_to, @id

exec @individual_sum = zadanie.dbo.SumOfInactiveMinutes @data1=@date_from, @data2=@date_to, @deviceid=@id, @ifreturn = 1

--SELECT @individual_sum

SET @Overal_sum = @Overal_sum + ISNULL(@individual_sum, 0)
--SELECT @overal_sum

FETCH NEXT FROM kursor INTO @id

END
CLOSE kursor
DEALLOCATE kursor

SELECT @overal_sum

END

GO
/****** Object:  StoredProcedure [dbo].[SumOfInactiveMinutes]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[SumOfInactiveMinutes] 
(
	-- Add the parameters for the function here
	@data1 datetime,
	@data2 datetime,
	@deviceid int,
	@ifreturn int
)
AS
BEGIN
	
	declare
	@tmp_table_base table (id int, id_awaria int, poczatek_naprawy datetime, koniec_naprawy datetime)
	INSERT INTO @tmp_table_base
(
    id, id_awaria, poczatek_naprawy, koniec_naprawy)
EXEC zadanie.[dbo].[getAgregateIntervals] @data1, @data2, @deviceid



IF @ifreturn = 1
BEGIN 
return (
        SELECT /*id,id_awaria,poczatek_naprawy,koniec_naprawy, */
               sum(zadanie.[dbo].[getMinutesFromDates] (poczatek_naprawy, koniec_naprawy))
        FROM @tmp_table_base
)
END
ELSE
BEGIN
SELECT /*id,id_awaria,poczatek_naprawy,koniec_naprawy, */
       sum(zadanie.[dbo].[getMinutesFromDates] (poczatek_naprawy, koniec_naprawy))
FROM @tmp_table_base
END

END
GO
/****** Object:  StoredProcedure [dbo].[Unit_with_longest_malfunctions]    Script Date: 21.01.2023 15:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[Unit_with_longest_malfunctions] 
(
	-- Add the parameters for the function here
	@date_from datetime,
	@date_to datetime
)
AS
BEGIN
	
DECLARE @individual_sum int = 0

declare @tmp_table table (id int, malfunciton_time int)

DECLARE kursor CURSOR FOR SELECT DISTINCT urzadzenie_id from zadanie.dbo.usterka
DECLARE @id int
OPEN kursor 
FETCH NEXT FROM kursor into @id
WHILE @@FETCH_STATUS = 0
BEGIN

--SELECT @id, @date_from, @date_to
--exec zadanie.dbo.SumOfInactiveMinutes @date_from, @date_to, @id

exec @individual_sum = zadanie.dbo.SumOfInactiveMinutes @data1=@date_from, @data2=@date_to, @deviceid=@id, @ifreturn = 1

--SELECT @individual_sum

INSERT INTO @tmp_table values (@id, ISNULL(@individual_sum, 0))
--SELECT @overal_sum

FETCH NEXT FROM kursor INTO @id

END
CLOSE kursor
DEALLOCATE kursor

SELECT b.oddzial_id,sum(a.malfunciton_time) as malfunction_time_sum
into #temp
FROM @tmp_table a
INNER JOIN zadanie.dbo.urzadzenie b
ON a.id = b.id
GROUP BY b.oddzial_id
ORDER BY 2 DESC

SELECT TOP 1 oddzial_id
From #temp



END

GO
