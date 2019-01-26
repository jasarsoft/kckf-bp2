CREATE DATABASE EnsarMeskovic_V14

USE EnsarMeskovic_V14
GO

CREATE TABLE Drzave
(
	DrzavaID	INT				IDENTITY PRIMARY KEY,
	Naziv		NVARCHAR(100)	NOT NULL
)

CREATE TABLE Gradovi
(
	GradID		INT				IDENTITY PRIMARY KEY,
	Naziv		NVARCHAR(100)	NOT NULL,
	DrzavaID	INT				FOREIGN KEY REFERENCES Drzave(DrzavaID)
)

CREATE TABLE Gosti
(
	GostID			INT				IDENTITY	PRIMARY KEY,
	Ime				NVARCHAR(100)	NOT NULL,
	Prezime			NVARCHAR(100)	NOT NULL,
	JMB				NVARCHAR(13)	NOT NULL UNIQUE,
	DatumRodjenja	DATE			NULL,
	Spol			CHAR(1)			NOT NULL,
	GradID			INT				NULL FOREIGN KEY REFERENCES Gradovi(GradID),
	Adresa			NVARCHAR(100)	NULL,
	Telefon			NVARCHAR(100)	NULL,
	Mail			NVARCHAR(100)	NULL
)

CREATE TABLE Rezervacije
(
	RezervacijaID	INT				IDENTITY	PRIMARY KEY,
	DatumDolaska	DATE			NOT NULL,
	DatumOdlaska	DATE			NOT NULL
)

CREATE TABLE GostRezervacije
(
	GostID				INT				FOREIGN KEY REFERENCES Gosti(GostID),
	RezervacijaID		INT				FOREIGN KEY REFERENCES Rezervacije(RezervacijaID),
	BrojSobe			INT				NOT NULL,
	CijenaNocenja		DECIMAL(10,2)	NOT NULL,
	NosilacRezervacije	BIT				NOT NULL DEFAULT (0),
	PRIMARY KEY (GostID, RezervacijaID)
)

CREATE TABLE Usluge
(
	UslugaID			INT				IDENTITY	PRIMARY KEY,
	Naziv				NVARCHAR(100)	NOT NULL,
	Cijena				DECIMAL(10,2)	NOT NULL
)

CREATE TABLE GostRezervacijaUsluga
(
	GostID				INT				NOT NULL,
	RezervacijaID		INT				NOT NULL,
	UslugaID			INT				FOREIGN KEY REFERENCES Usluge(UslugaID),
	Datum				DATE			NOT NULL,
	Vrijeme				TIME			NOT NULL,
	FOREIGN KEY  (GostID, RezervacijaID) REFERENCES GostRezervacije  (GostID, RezervacijaID),
	PRIMARY KEY (GostID, RezervacijaID, UslugaID)
)