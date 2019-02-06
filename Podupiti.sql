USE ImePrezime_V9
GO

--1 Zadatak (6. zadatak - Susret 9)

--Kreiranje view-a: CREATE VIEW [shema].[naziv] AS ::definicija::
CREATE VIEW [dbo].[vw_RezultatiTestova_SelectByOznaka]
AS

SELECT T1.Ime + ' ' + T1.Prezime AS [Ime i prezime], T1.JMBG, T1.Telefon, T1.Email, T3.Datum, T3.Naziv, T3.Oznaka, T3.Oblast, T3.MaxBrojBodova, T2.Polozio, T2.OsvojeniBodovi, LEFT(CONVERT(nvarchar,((T2.OsvojeniBodovi / T3.MaxBrojBodova) * 100)), 5) + '%' AS [Procentualni rezultat testa]
FROM Kandidati AS T1
	JOIN RezultatiTestova AS T2 
		ON T1.KandidatID = T2.KandidatID
	JOIN Testovi AS T3 
		ON T2.TestID = T3.TestID
WHERE T3.Oznaka LIKE 'BP1'

--Ispis podataka iz View-a
SELECT * FROM [dbo].[vw_RezultatiTestova_SelectByOznaka]


--Kreiranje uskladistene procedure koja prima parametar za oznaku
CREATE PROCEDURE [dbo].[usp_RezultatiTestova_SelectByOznaka]
(
	@Oznaka NVARCHAR(10)
)
AS
BEGIN
	SELECT T1.Ime + ' ' + T1.Prezime AS [Ime i prezime], T1.JMBG, T1.Telefon, T1.Email, T3.Datum, T3.Naziv, T3.Oznaka, T3.Oblast, T3.MaxBrojBodova, T2.Polozio, T2.OsvojeniBodovi, LEFT(CONVERT(nvarchar,((T2.OsvojeniBodovi / T3.MaxBrojBodova) * 100)), 5) + '%' AS [Procentualni rezultat testa]
	FROM Kandidati AS T1
		JOIN RezultatiTestova AS T2 
			ON T1.KandidatID = T2.KandidatID
		JOIN Testovi AS T3 
			ON T2.TestID = T3.TestID
	WHERE T3.Oznaka = @Oznaka
END

--Ispis podataka koristeci proceduru
EXECUTE [dbo].[usp_RezultatiTestova_SelectByOznaka] 'BP1'
EXECUTE [dbo].[usp_RezultatiTestova_SelectByOznaka] @Oznaka = 'PR2'



--2 Zadatak (7. zadatak - Susret 9)

SELECT *
FROM (
SELECT T1.Naziv, T1.Datum, 
( SELECT COUNT(Polozio) 
  FROM RezultatiTestova AS SQT1
  WHERE SQT1.Polozio = 1 AND SQT1.TestID = T1.TestID ) AS Polozili,
( SELECT COUNT(Polozio)
  FROM RezultatiTestova AS SQT1
  WHERE SQT1.Polozio = 0 AND SQT1.TestID = T1.TestID ) AS Pali
FROM Testovi AS T1
GROUP BY T1.TestID, T1.Naziv, T1.Datum
) AS RezultatiTestova
WHERE RezultatiTestova.Polozili > 1

--Kreiranje view-a (izvlacimo podupit iz prethodnog zadatka u view)
CREATE VIEW [dbo].[vw_Testovi_SelectPoloziliPali]
AS 

SELECT T1.Naziv, T1.Datum, 
( SELECT COUNT(Polozio) 
  FROM RezultatiTestova AS SQT1
  WHERE SQT1.Polozio = 1 AND SQT1.TestID = T1.TestID ) AS Polozili,
( SELECT COUNT(Polozio)
  FROM RezultatiTestova AS SQT1
  WHERE SQT1.Polozio = 0 AND SQT1.TestID = T1.TestID ) AS Pali
FROM Testovi AS T1
GROUP BY T1.TestID, T1.Naziv, T1.Datum


-- Ispis uz koristenje view-a
SELECT *
FROM [dbo].[vw_Testovi_SelectPoloziliPali] AS [RezultatiTestova]
WHERE RezultatiTestova.Polozili > 1