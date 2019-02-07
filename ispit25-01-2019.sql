
CREATE DATABASE EdinJasarevic_BPII
GO

USE EdinJasarevic_BPII
GO

-- tabela gradoivi
CREATE TABLE Gradovi
(
	GradID		INT IDENTITY(1,1) CONSTRAINT PK_Grad PRIMARY KEY, --na dalje sam koristi jednostavno bez naziva ogranicenja
	Naziv		NVARCHAR(32) NOT NULL
)
GO

-- tabela narudzba
CREATE TABLE Narudzba --ovdje je treablo Naruzbe naziv
(
	NarudzbaID		INT IDENTITY PRIMARY KEY,
	Sifra			NVARCHAR(10) NOT NULL CONSTRAINT UQ_Narudzba_Sifra UNIQUE,
	DatumNarudzbe	DATETIME NOT NULL,
	DatumIsporuke	DATETIME NULL,
	AdresaIsporuke  NVARCHAR(100) NOT NULL,
	GradIsporukeID	INT NOT NULL FOREIGN KEY REFERENCES Gradovi(GradID),
)
GO

-- tabela artikli
CREATE TABLE Artikli
(
	ArtiklID		INT IDENTITY PRIMARY KEY,
	Naziv			NVARCHAR(100) NOT NULL,
	Aktivan			BIT NOT NULL DEFAULT 1
)
GO

-- tablea narudzba artikli
CREATE TABLE NarudbaArtikli
(
	NarudzbaId		INT NOT NULL FOREIGN KEY REFERENCES Narudzba(NarudzbaID),
	ArtiklId		INT NOT NULL FOREIGN KEY REFERENCES Artikli(ArtiklID),
	Cijena			DECIMAL NOT NULL, -- DECIMAL(18,2)
	Kvantitet		INT NOT NULL DEFAULT 1,
	--Popust			DECIMAL(5, 2), -- stavio sam ovako jer popust moze biti 100.00% sto je 5 cifara a 2 za decimalno mjesto
	Popust			DECIMAL(3, 2) --od 0.00 do 9.99 dovoljno je 3 cifre jer 0.10 je 10% popusta
	PRIMARY KEY(NarudzbaId, ArtiklId)
)
GO

-- ubacivanje gradova
INSERT INTO Gradovi (Naziv)
	VALUES	('Mostar'),
			('Zenica'),
			('Sarajevo'),
			('Tuzla'),
			('Bihac');

SELECT * FROM Gradovi;

-- ubacivanje narudzbi
INSERT INTO Narudzba
VALUES	('Sifra001', '1.1.2019', '1.2.2019', 'Adresa001', 1),
		('Sifra002', '1.1.2019', '1.2.2019', 'Adresa002', 2),
		('Sifra003', '1.1.2019', '1.2.2019', 'Adresa003', 3),
		('Sifra004', '1.1.2019', '1.2.2019', 'Adresa004', 4),
		('Sifra005', '1.1.2019', '1.2.2019', 'Adresa005', 5)
GO

INSERT INTO Narudzba
VALUES	('Sifra006', '1.1.2019', NULL, 'Adresa006', 1),
		('Sifra007', '1.1.2019', NULL, 'Adresa007', 2)
GO

SELECT * FROM Narudzba;	  
	  
-- ubacivanje artikala
INSERT INTO Artikli
VALUES	('Artikl001',  1),
		('Artikl002',  1),
		('Artikl003',  1),
		('Artikl004',  1),
		('Artikl005',  0)
GO

SELECT * FROM Artikli;

-- narudzbe arikala
INSERT INTO NarudbaArtikli
VALUES	(3, 1, 100, 1, 0.17),
		(3, 2, 100, 1, 0.17),
		(3, 3, 100, 1, 0.17),
		(3, 4, 100, 1, 0.17),
		(3, 5, 100, 1, 0.17),
		(4, 1, 10, 5, 0.10),
		(4, 2, 10, 5, 0.10),
		(4, 3, 10, 5, 0.10),
		(4, 4, 10, 5, 0.10),
		(5, 1, 5, 1, 0),
		(5, 2, 5, 1, 0),
		(5, 3, 5, 1, 0)
GO

INSERT INTO NarudbaArtikli
VALUES	(8, 1, 10, 1, 0),
		(8, 2, 10, 1, 0),
		(8, 3, 10, 1, 0)		
GO

SELECT * FROM NarudbaArtikli;


-- 2. pogled
CREATE VIEW vw_Naruzba_SifraDatumUkpArtikl
AS
	SELECT	N.Sifra AS "Sifra narudzbe",
			N.DatumNarudzbe AS "Datum narudzbe",
			COUNT(NA.ArtiklId) AS "Ukupan broj artikala"
	FROM Narudzba AS N
		JOIN NarudbaArtikli AS NA ON N.NarudzbaID = NA.NarudzbaId
	WHERE N.DatumIsporuke IS NULL
	GROUP BY N.Sifra, N.DatumNarudzbe

SELECT * FROM vw_Naruzba_SifraDatumUkpArtikl;


-- 3 procedura
CREATE PROCEDURE proc_ZaradaPoArtiklu
	@YEAR int
AS
BEGIN
	SELECT	A.Naziv,
			ROUND(SUM((NA.Cijena * NA.Kvantitet) * (1 - NA.Popust)), 2) AS "Ukpuna zarada sa popusta",
			ROUND(SUM(NA.Cijena * NA.Kvantitet), 2) AS "Ukpuna zarada bez popusta"
	FROM Narudzba AS N
		JOIN NarudbaArtikli AS NA ON N.NarudzbaID = NA.NarudzbaId
		JOIN Artikli AS A ON A.ArtiklID = NA.ArtiklId
	WHERE YEAR(N.DatumNarudzbe) = @YEAR
	GROUP BY A.Naziv
	HAVING ROUND(SUM((NA.Cijena * NA.Kvantitet) * (1 - NA.Popust)), 2) > 100
END

EXECUTE proc_ZaradaPoArtiklu 2019


-- zadatak 4
UPDATE Artikli
	SET Aktivan = 1
	WHERE Aktivan = 0

SELECT * FROM Artikli;

-- zadatak 5
DELETE FROM Gradovi
WHERE Naziv LIKE 'A%'

SELECT * FROM Gradovi;
INSERT INTO Gradovi (Naziv)
	VALUES	('Amsterdam')


-- zadatak 6
USE master
GO
DROP DATABASE EdinJasarevic_BPII