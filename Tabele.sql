USE EdinJasarevic_v10;

CREATE TABLE Kandidati (
	KandidatID INT PRIMARY KEY IDENTITY,
	Ime NVARCHAR(30) NOT NULL,
	Prezime NVARCHAR(30) NOT NULL,
	JMBG CHAR(13) NOT NULL UNIQUE,
	DatumRodjenja DATE NOT NULL,
	MjestoRodjenja NVARCHAR(30),
	Telefon NVARCHAR(20),
	Email NVARCHAR(50) UNIQUE
);

CREATE TABLE Testovi (
	TestID INT PRIMARY KEY IDENTITY,
	Datum DATETIME NOT NULL,
	Naziv NVARCHAR(50) NOT NULL,
	Oznaka NVARCHAR(10) NOT NULL UNIQUE,
	Oblast NVARCHAR(50) NOT NULL,
	MaxBrojBodova INT NOT NULL,
	Opis NVARCHAR(250)
);

CREATE TABLE RezultatiTesta (
	KandidatId INT NOT NULL,
	TestId INT NOT NULL,
	Polozio BIT NOT NULL,
	OsvojeniBodovi DECIMAL(3,2) NOT NULL,
	Napomena NVARCHAR(MAX),
	CONSTRAINT FK_RezultatiTesta_KandidatID FOREIGN KEY (KandidatId) REFERENCES Kandidati(KandidatID),
	CONSTRAINT FK_RezultatiTesta_TestID FOREIGN KEY (TestId) REFERENCES Testovi(TestID),
	PRIMARY KEY (KandidatId, TestId)
);

CREATE TABLE Gradovi (
	GradID INT PRIMARY KEY IDENTITY,
	Naziv NVARCHAR(30) NOT NULL
);

ALTER TABLE Kandidati 
	ADD Adresa NVARCHAR(50)


ALTER TABLE Kandidati
	ADD GradID INT NULL

ALTER TABLE Kandidati
	ADD CONSTRAINT FK_Kandidati_GradID FOREIGN KEY (GradID) REFERENCES Gradovi(GradID);


INSERT INTO Gradovi (Naziv)
	VALUES	('Mostar'),
			('Zenica'),
			('Sarajevo');


INSERT INTO Kandidati(Ime, Prezime, JMBG, DatumRodjenja, MjestoRodjenja, Telefon, Email, GradID) VALUES
	--SELECT TOP 10 FirstName, LastName, '0123456789012', CONVERT(DATE, BirthDate, 104), City, HomePhone, '1'
	--FROM NORTHWND.dbo.Employees
	('Ime1', 'Prezime1', '0123456789012', '1.1.2000', 'Mostar', '111222', 'meil@oo.ba', 1),
	('Ime2', 'Prezime2', '0123456789052', '7.7.2002', 'Zenica', '111777', 'meil@aa.ba', 2),
	('Ime3', 'Prezime3', '0123456789013', '6.6.2003', 'Sarajevo', '111666', 'meil@dd.ba', 3),
	('Ime4', 'Prezime4', '0123456789014', '5.5.2004', 'Mostar', '111555', 'meil@cc.ba', 1),
	('Ime5', 'Prezime5', '0123456789015', '4.4.2005', 'Zenica', '111333', 'meil@bb.ba', 2);

SELECT * FROM Kandidati;

INSERT INTO Testovi(Datum, Naziv, Oznaka, Oblast, MaxBrojBodova) VALUES
	('1.1.2001', 'Baze 1', 'BP1', 'IT', 90),
	('2.2.2002', 'Baze 2', 'BP2', 'IT', 80),
	('3.3.2003', 'Baze 3', 'BP3', 'IT', 70);

SELECT * FROM Testovi;

INSERT INTO RezultatiTesta(KandidatId, TestId, Polozio, OsvojeniBodovi) VALUES
	(6, 1, 1, 8.0),
	(6, 2, 1, 7.0),
	(6, 3, 1, 9.0),
	(9, 1, 1, 8.0),
	(9, 2, 1, 7.0),
	(9, 3, 1, 9.0),
	(10, 1, 1, 8.0),
	(10, 2, 1, 7.0),
	(10, 3, 1, 9.0),
	(11, 1, 1, 8.0),
	(11, 2, 1, 7.0),
	(11, 3, 1, 9.0);

SELECT * FROM RezultatiTesta;

/*
	5. Kreirati upit koji prikazuje rezultate testiranja za odreðeni test 
	(oznaka testa kao filter). Kao rezultat upita prikazati sljedeæe kolone: 
	ime i prezime, jmbg, telefon i email kandidata, zatim datum, naziv, oznaku, 
	oblast i maksimalan broj bodova na testu, te polje položio, osvojene bodove 
	i procentualni rezultat testa.
*/

SELECT K.Ime, K.Prezime, K.JMBG, K.Telefon, K.Email,
		T.Datum, T.Naziv, T.Oznaka, T.Oblast, T.MaxBrojBodova,
		RT.Polozio, RT.OsvojeniBodovi,
		(RT.OsvojeniBodovi / T.MaxBrojBodova) * 100 AS "Procenat"
		
FROM Kandidati AS K 
	JOIN RezultatiTesta AS RT ON RT.KandidatId = K.KandidatID
	JOIN Testovi AS T ON RT.TestId = T.TestID
WHERE T.Naziv = 'Baze 1';

/*
	6. Obrisati jedan test i ostvarene rezultate na testu (oznaka testa kao filter).
*/

DELETE RT FROM RezultatiTesta AS RT JOIN Testovi AS T ON T.TestID = RT.TestId
WHERE T.Oznaka = 'BP1';