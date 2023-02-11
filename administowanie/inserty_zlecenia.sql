/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [id]
      ,[opis]
      ,[ilosc]
      ,[data_zlecenia]
  FROM [zadanie_new].[dbo].[zlecenia]
  ;

  update zadanie_new.dbo.zlecenia set data_zlecenia = '2022-12-01';

  insert into zadanie_new.dbo.zlecenia (opis ,ilosc ,data_zlecenia) values
 /*2 */ ('breloczki z logiem toyoty',	1000,	'2022-12-01'),
 /*3 */ ('breloczki z logiem hondy',	1000,	'2022-12-01'),
 /*4 */ ('breloczki z logiem suzuki',	1000,	'2022-12-01'),
 /*5 */ ('breloczki z logiem ¿uka',		1000,	'2022-12-01'),
 /*6 */ ('dlugopis z logiem toyoty',	1000,	'2022-12-01'),
 /*7 */ ('dlugopis z logiem hondy',		1000,	'2022-12-01'),
 /*8 */ ('dlugopis z logiem suzuki',	1000,	'2022-12-01'),
 /*9 */ ('dlugopis z logiem ¿uka',		1000,	'2022-12-01'),
 /*10*/ ('zawieszka z logiem ¿uka',		1000,	'2022-12-01'),
 /*11*/ ('zawieszka z logiem toyoty',	1000,	'2022-12-01'),
 /*12*/ ('zawieszka z logiem hondy',	1000,	'2022-12-01'),
 /*13*/ ('zawieszka z logiem suzuki',	1000,	'2022-12-01');

  insert into zadanie_new.dbo.estymata 
	(oddzial_id, zlecenie_id, szacunek) values
/*5	*/	(1,			2,			'23:00:00'),
/*6	*/	(1,			3,			'23:00:00'),
/*7	*/	(1,			4,			'23:00:00'),
/*8	*/	(1,			5,			'23:00:00'),
/*9	*/	(2,			6,			'23:00:00'),
/*10*/	(2,			7,			'23:00:00'),
/*11*/	(2,			8,			'23:00:00'),
/*12*/	(2,			9,			'23:00:00'),
/*13*/	(1,			10,			'23:00:00'),
/*14*/	(1,			11,			'23:00:00'),
/*15*/	(1,			12,			'23:00:00'),
/*16*/	(1,			13,			'23:00:00');

SELECT TOP (1000) [id]
      ,[oddzial_id]
      ,[nazwa]
  FROM [zadanie_new].[dbo].[pracownik];

  SELECT TOP (1000) [id]
      ,[nazwa]
      ,[kod_oddzialu]
  FROM [zadanie_new].[dbo].[oddzial];

  SELECT TOP (1000) [id]
      ,[kod]
      ,[opis]
  FROM [zadanie_new].[dbo].[zlecenie_status];
  
  insert into [zadanie_new].[dbo].[zlecenie_status] values (6, N'zlecenie oczekujace');

  alter table zadanie_new.dbo.zlecenie_realizacja drop status_id;
  sp_rename 'zadanie_new.dbo.zlecenie_realizacja.zlecenie_status', 'zlecenie_status_id', 'COLUMN';

 insert into zadanie_new.dbo.zlecenie_realizacja 
	(oddzial_id ,pracownik_id ,zlecenie_id ,zlecenie_poczatek ,zlecenie_koniec ,zlecenie_status_id ,zlecenie_estymata_id) values
	(1,			1,				2,			 '2022-12-01',		'2022-12-22',	1,				 5),
	(1,			2,				3,			 '2022-12-01',		'2022-12-22',	1,				 5),
	(1,			1,				4,			 null,				null,			6,				 5),
	(1,			2,				5,			 null,				null,			6,				 5),
	(2,			3,				6,			 '2022-12-19',		'2022-12-22',	1,				 5),
	(2,			4,				7,			 '2022-12-19',		'2022-12-22',	1,				 5),	
	(2,			3,				8,			 null,				null,			6,				 5),
	(2,			4,				9,			 null,				null,			6,				 5),	
	(1,			1,				10,			 null,				null,			6,				 5),
	(1,			2,				11,			 null,				null,			6,				 5),
	(1,			1,				12,			 null,				null,			6,				 5),
	(1,			2,				13,			 null,				null,			6,				 5);
go

select oddzial_id, count(*) ilosc_zlecen_do_realizacji
from zadanie_new.dbo.zlecenie_realizacja 
where zlecenie_status_id <>5
group by oddzial_id;


update zadanie_new.dbo.estymata set szacunek=23;


select r.oddzial_id, sum(e.szacunek)  sum_szacunek
from
zadanie_new.dbo.zlecenie_realizacja r
join zadanie_new.dbo.estymata e on r.zlecenie_estymata_id=e.id
group by r.oddzial_id;


SELECT TOP 1 urz.oddzial_id,count(ust.id) as count_no
FROM zadanie_new.dbo.usterka ust
INNER JOIN zadanie_new.dbo.urzadzenie urz
ON ust.urzadzenie_id=urz.id
WHERE ust.data_zgloszenia between '2022-12-01' and '2022-12-22'
group by urz.oddzial_id
;


select * from zadanie_new.dbo.getmalfunction ('2022-12-01', '2022-12-22',1);

select zadanie_new.dbo.getShiftsFromDates ('2022-12-01', '2022-12-22');