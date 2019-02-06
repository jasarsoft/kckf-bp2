USE master
GO

CREATE DATABASE TestBaza321

USE TestBaza321
GO

CREATE TABLE Gradovi 
(
	GradID			INT		IDENTITY(1,1) PRIMARY KEY,
	Naziv			NVARCHAR(75)	NOT NULL
)

CREATE TABLE Polaznici
(
	PolaznikID		INT				IDENTITY(1,1)	PRIMARY KEY,
	Ime				NVARCHAR(30)	NOT NULL,
	Prezime			NVARCHAR(50)	NOT NULL,
	Spol			CHAR(1)			NOT NULL,
	Email			NVARCHAR(50)	NOT NULL		CONSTRAINT UQ_Polaznici_Email UNIQUE,
	KontaktTelefon	NVARCHAR(20)	NULL,
	GradID			INT				NULL			FOREIGN KEY REFERENCES Gradovi(GradID),
	Aktivan			BIT				NOT NULL		DEFAULT 1
)




CREATE TABLE Kursevi
(
	KursID			INT			IDENTITY(1,1)		PRIMARY KEY,
	Naziv			NVARCHAR(50)	NOT NULL,
	DatumPocetka	DATE			NOT NULL,
	DatumZavrsetka	DATE			NOT NULL,
	Napomena		NVARCHAR(MAX)	NULL
)

CREATE TABLE PolazniciKursevi
(
	PolaznikID		INT		FOREIGN KEY REFERENCES Polaznici(PolaznikID), --FOREIGN KEY ukljucuje REFERENCIJALNI INTEGRITET
	KursID			INT		FOREIGN KEY REFERENCES Kursevi(KursID), -- REFERENCES samo 'povezuje' tabele bez ukljucenog referencijalnog integriteta
	Odustao			BIT		NOT NULL	DEFAULT 0,
	Polozio			BIT		NOT NULL	DEFAULT 0,
	Ocjena			INT		NULL,
	PRIMARY KEY(PolaznikID, KursID)
)



--Kreirati upit koji prikazuje ime i prezime polaznika, email i kontakt telefon, ali samo za polaznike ženskog spola, te da pohaðaju neki od kurseva.

SELECT [T1].[Ime] + ' ' + [T1].[Prezime] AS [ImePrezime], 
	   [T1].[Email], 
	   [T1].[KontaktTelefon],
	   [T1].[Spol]
FROM [dbo].[Polaznici]				AS [T1]
	 JOIN [dbo].[PolazniciKursevi]	AS [T2]	ON [T1].[PolaznikID] = [T2].[PolaznikID]
WHERE [T1].[Spol] = 'F'

--Kreirati upit koji prikazuje ime i prezime polaznika, spol i prosjeènu ocjenu.

SELECT [T1].[Ime] + ' ' + [T1].[Prezime] AS [ImePrezime], 
	   [T1].[Spol], 
	   AVG([T2].[Ocjena]) AS [ProsjecnaOcjena]
FROM [dbo].[Polaznici]				AS [T1]
	 JOIN [dbo].[PolazniciKursevi]	AS [T2] ON [T2].[PolaznikID] = [T1].[PolaznikID]
GROUP BY [T1].[Ime],
		 [T1].[Prezime],
		 [T1].[Spol]

--Kreirati upit koji prikazuje ukupan broj ocjena i prosjeènu ocjenu na odabranom kursu. 

ALTER PROCEDURE [dbo].[usp_PolazniciKursevi_SelectByNaziv]
(
	@Kurs	NVARCHAR(50) = NULL
)
AS
BEGIN
	SELECT COUNT([T1].[Ocjena]) AS [BrojOcjena],
		   AVG([T1].[Ocjena]) AS [ProsjecnaOcjena]
	FROM [dbo].[PolazniciKursevi]	AS [T1]
		 JOIN [dbo].[Kursevi]		AS [T2] ON [T1].[KursID] = [T2].[KursID]
	WHERE [T2].[Naziv] = @Kurs OR @Kurs IS NULL
END

EXECUTE [dbo].[usp_PolazniciKursevi_SelectByNaziv]

--Kreirati upit koji prikazuje kurseve kojima je godina poèetka kursa jednaka godini koju korisnik unosi prilikom pokretanja upita.

SELECT [T1].[Naziv], [T1].[DatumPocetka], [T1].[DatumZavrsetka]
FROM [dbo].[Kursevi]	AS [T1]
WHERE DATEPART(year, [T1].[DatumPocetka]) = 2018