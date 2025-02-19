USE [zadanie]
GO
/****** Object:  UserDefinedFunction [dbo].[getMinutesFromDates]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  UserDefinedFunction [dbo].[getShiftsFromDates]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  UserDefinedFunction [dbo].[shift_no]    Script Date: 17.12.2022 15:41:50 ******/
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
						 ELSE 2
						 END

	RETURN @shift_no

END
GO
/****** Object:  Table [dbo].[usterka]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  UserDefinedFunction [dbo].[getmalfunction]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  Table [dbo].[estymata]    Script Date: 17.12.2022 15:41:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[estymata](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[oddzial_id] [int] NULL,
	[zlecenie_id] [int] NULL,
	[szacunek] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[firma]    Script Date: 17.12.2022 15:41:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[firma](
	[id] [int] NOT NULL,
	[nazwa] [varchar](255) NULL,
 CONSTRAINT [PK_firma] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[oddzial]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  Table [dbo].[pracownik]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  Table [dbo].[urzadzenie]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  Table [dbo].[urzadzenie_status]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  Table [dbo].[usterka_status]    Script Date: 17.12.2022 15:41:50 ******/
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
/****** Object:  Table [dbo].[zlecenia]    Script Date: 17.12.2022 15:41:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zlecenia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[opis] [varchar](255) NULL,
	[ilosc] [int] NULL,
	[data_zlecenia] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zlecenie_realizacja]    Script Date: 17.12.2022 15:41:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zlecenie_realizacja](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[oddzial_id] [int] NULL,
	[pracownik_id] [int] NULL,
	[zlecenie_id] [int] NULL,
	[zlecenie_poczatek] [datetime] NULL,
	[zlecenie_koniec] [datetime] NULL,
	[zlecenie_status] [int] NULL,
	[zlecenie_estymata_id] [int] NULL,
	[status_id] [int] NULL,
 CONSTRAINT [PK__zlecenie__3213E83F4FAD5E68] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zlecenie_status]    Script Date: 17.12.2022 15:41:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zlecenie_status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[kod] [int] NULL,
	[opis] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[firma] ([id], [nazwa]) VALUES (1, N'BuBuBiBi 3D Company')
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
SET IDENTITY_INSERT [dbo].[zlecenie_status] ON 

INSERT [dbo].[zlecenie_status] ([id], [kod], [opis]) VALUES (1, 1, N'zlecenie rozpoczete')
INSERT [dbo].[zlecenie_status] ([id], [kod], [opis]) VALUES (2, 2, N'awaria urządzenia')
INSERT [dbo].[zlecenie_status] ([id], [kod], [opis]) VALUES (3, 3, N'brak surowca')
INSERT [dbo].[zlecenie_status] ([id], [kod], [opis]) VALUES (4, 4, N'zlecenie wznowione')
INSERT [dbo].[zlecenie_status] ([id], [kod], [opis]) VALUES (5, 5, N'zlecenie zakonczone')
SET IDENTITY_INSERT [dbo].[zlecenie_status] OFF
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
ALTER TABLE [dbo].[zlecenie_realizacja]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_realizacja_estymata] FOREIGN KEY([zlecenie_estymata_id])
REFERENCES [dbo].[estymata] ([id])
GO
ALTER TABLE [dbo].[zlecenie_realizacja] CHECK CONSTRAINT [FK_zlecenie_realizacja_estymata]
GO
ALTER TABLE [dbo].[zlecenie_realizacja]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_realizacja_oddzial] FOREIGN KEY([oddzial_id])
REFERENCES [dbo].[oddzial] ([id])
GO
ALTER TABLE [dbo].[zlecenie_realizacja] CHECK CONSTRAINT [FK_zlecenie_realizacja_oddzial]
GO
ALTER TABLE [dbo].[zlecenie_realizacja]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_realizacja_pracownik] FOREIGN KEY([pracownik_id])
REFERENCES [dbo].[pracownik] ([id])
GO
ALTER TABLE [dbo].[zlecenie_realizacja] CHECK CONSTRAINT [FK_zlecenie_realizacja_pracownik]
GO
ALTER TABLE [dbo].[zlecenie_realizacja]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_realizacja_zlecenia] FOREIGN KEY([zlecenie_id])
REFERENCES [dbo].[zlecenia] ([id])
GO
ALTER TABLE [dbo].[zlecenie_realizacja] CHECK CONSTRAINT [FK_zlecenie_realizacja_zlecenia]
GO
ALTER TABLE [dbo].[zlecenie_realizacja]  WITH CHECK ADD  CONSTRAINT [FK_zlecenie_realizacja_zlecenie_status] FOREIGN KEY([status_id])
REFERENCES [dbo].[zlecenie_status] ([id])
GO
ALTER TABLE [dbo].[zlecenie_realizacja] CHECK CONSTRAINT [FK_zlecenie_realizacja_zlecenie_status]
GO
/****** Object:  StoredProcedure [dbo].[getAgregateIntervals]    Script Date: 17.12.2022 15:41:51 ******/
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
/****** Object:  StoredProcedure [dbo].[SumOfInactiveMinutes]    Script Date: 17.12.2022 15:41:51 ******/
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
	@deviceid int
)
AS
BEGIN
	
	declare
	@tmp_table_base table (id int, id_awaria int, poczatek_naprawy datetime, koniec_naprawy datetime)
	INSERT INTO @tmp_table_base
(
    id, id_awaria, poczatek_naprawy, koniec_naprawy)
EXEC zadanie.[dbo].[getAgregateIntervals] @data1, @data2, @deviceid

SELECT /*id,id_awaria,poczatek_naprawy,koniec_naprawy, */
sum(zadanie.[dbo].[getMinutesFromDates] (poczatek_naprawy, koniec_naprawy))
FROM @tmp_table_base


END
GO
