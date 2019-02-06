--1
USE master
GO
CREATE DATABASE ImePrezime_V9

--2
USE ImePrezime_V9
GO
CREATE TABLE Kandidati 
(
	KandidatID int IDENTITY(1,1) CONSTRAINT PK_Kandidat PRIMARY KEY,
	Ime nvarchar(30) NOT NULL,
	Prezime nvarchar(30) NOT NULL,
	JMBG nvarchar(13) NOT NULL CONSTRAINT UQ_JMBG UNIQUE,
	DatumRodjenja date NOT NULL,
	MjestoRodjenja nvarchar(30) NULL,
	Telefon nvarchar(20) NULL,
	Email nvarchar(50) CONSTRAINT UQ_Email UNIQUE
)

CREATE TABLE Testovi
(
	TestID int IDENTITY(1,1) CONSTRAINT PK_Test PRIMARY KEY,
	Datum smalldatetime NOT NULL,
	Naziv nvarchar(50) NOT NULL,
	Oznaka nvarchar(10) NOT NULL CONSTRAINT UQ_Oznaka UNIQUE,
	Oblast nvarchar(50) NOT NULL,
	MaxBrojBodova smallint NOT NULL,
	Opis nvarchar(250) NULL
)

CREATE TABLE RezultatiTestova
(
	KandidatID int NOT NULL CONSTRAINT FK_RezultatiTestova_Kandidati FOREIGN KEY REFERENCES Kandidati (KandidatID),
	TestID int NOT NULL CONSTRAINT FK_RezultatiTestova_Testovi FOREIGN KEY REFERENCES Testovi (TestID),
	Polozio bit NOT NULL,
	OsvojeniBodovi decimal(7,2) NOT NULL,
	Napomena nvarchar(max),
	PRIMARY KEY (KandidatID, TestID)
)

CREATE TABLE Gradovi
(
	GradID int IDENTITY(1,1) CONSTRAINT PK_Grad PRIMARY KEY,
	Naziv nvarchar(100) NOT NULL
)

--3
ALTER TABLE Kandidati
ADD 
Adresa nvarchar(100) NULL, 
GradID int NULL CONSTRAINT FK_Kandidati_Gradovi FOREIGN KEY REFERENCES Gradovi (GradID)

--4
INSERT INTO Kandidati (Ime, Prezime, JMBG, DatumRodjenja, MjestoRodjenja, Telefon, Email)
SELECT TOP 10 E.FirstName, E.LastName, REPLACE(CONVERT(nvarchar(10), E.BirthDate, 104), '.', '0') + LEFT(E.Extension, 3) AS [JMB], E.BirthDate, E.City, E.HomePhone, LOWER(E.FirstName + '.' + E.LastName) + '@email.com' AS [Email]
FROM NORTHWND.dbo.Employees AS E

--5
INSERT INTO Testovi
VALUES('1.1.2015', 'Programiranje 2', 'PR2', 'Strukture', 100, 'a'),
	  ('1.2.2016', 'Baze Podataka 1', 'BP1', 'Kardinaliteti', 100, 'b'),
	  ('2.3.2017', 'Komunikacijske tehnologije', 'KT', 'Rutiranje', 100, 'c')

INSERT INTO RezultatiTestova
VALUES (1, 1, 1, 71, 'Polozio'),
	   (1, 2, 1, 80, 'Polozio'),
	   (2, 1, 0, 41, 'Nije polozio'),
	   (2, 3, 1, 90, 'Polozio'),
	   (3, 2, 1, 85, 'Polozio'),
	   (1, 3, 0, 25, 'Nije polozio'),
	   (2, 2, 0, 30, 'Nije polozio'),
	   (3, 1, 1, 67, 'Polozio'),
	   (3, 3, 0, 44, 'Nije polozio'),
	   (4, 1, 1, 69, 'Polozio')

--6
SELECT T1.Ime + ' ' + T1.Prezime AS [Ime i prezime], T1.JMBG, T1.Telefon, T1.Email, T3.Datum, T3.Naziv, T3.Oznaka, T3.Oblast, T3.MaxBrojBodova, T2.Polozio, T2.OsvojeniBodovi, LEFT(CONVERT(nvarchar,((T2.OsvojeniBodovi / T3.MaxBrojBodova) * 100)), 5) + '%' AS [Procentualni rezultat testa]
FROM Kandidati AS T1
	JOIN RezultatiTestova AS T2 
		ON T1.KandidatID = T2.KandidatID
	JOIN Testovi AS T3 
		ON T2.TestID = T3.TestID
WHERE T3.Oznaka = 'BP1'

--7
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

--8
UPDATE RezultatiTestova
SET OsvojeniBodovi = OsvojeniBodovi + 5
FROM Testovi
WHERE RezultatiTestova.Polozio = 1 AND RezultatiTestova.TestID = Testovi.TestID AND Testovi.Oznaka = 'BP1'

--9
DELETE FROM RezultatiTestova
FROM Testovi AS T1
	JOIN RezultatiTestova AS T2
		ON T1.TestID = T2.TestID
WHERE Oznaka LIKE 'KT'

DELETE FROM Testovi
WHERE Oznaka LIKE 'KT'

--10
ALTER TABLE Kandidati
DROP CONSTRAINT FK_Kandidati_Gradovi

ALTER TABLE Kandidati
DROP COLUMN
GradID,
Adresa

DROP TABLE Gradovi

--GRATIS
USE master
GO
DROP DATABASE ImePrezime_V9