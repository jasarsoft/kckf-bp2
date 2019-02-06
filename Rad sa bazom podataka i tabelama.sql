USE master
GO

CREATE DATABASE Prodaja
ON
  (NAME = Prodaja_dat, FILENAME = 'D:\DB\SQL Server\Prodaja.mdf', SIZE = 100MB, MAXSIZE = 500MB, FILEGROWTH = 20% )
LOG ON
  (NAME = Prodaja_log, FILENAME = 'D:\DB\SQL Server\Prodaja.ldf', SIZE = 20MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10MB );


DROP DATABASE Prodaja
GO


CREATE DATABASE Prodaja
GO
/* 
		Default postavke i lokacija koja je obicno:
		C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA
		zavisi od verzije i instance SQL Servera
*/


DECLARE @Hello nvarchar(20);

SET @Hello = N'Hello';
SELECT @Hello
SET @Hello = N'你好';
SELECT @Hello
SET @Hello = N'السلام عليكم';
SELECT @Hello


SELECT CAST(SYSDATETIME() AS nvarchar(30));

SELECT CONVERT(varchar(8),SYSDATETIME(),112);

SELECT CONVERT(char(8), 0x4E616d65, 0) 
AS 'Stil 0, binarni u tekstualni';

SELECT PARSE('Monday, 13 December 2010' AS datetime2 USING 'en-US');

USE Prodaja
GO

CREATE TYPE ProductNumber 
FROM nvarchar(20) NOT NULL;
GO

CREATE TABLE ProductConversion
(	ProductConversionID int IDENTITY(1,1),
	FromProduct ProductNumber,
	ToProduct ProductNumber
);


CREATE TABLE Kupci
( KupacID int IDENTITY(1,1),
  Prezime nvarchar(30) NOT NULL,
  Ime nvarchar(30) NOT NULL, 
  Telefon nvarchar (30) NULL
);


ALTER TABLE Kupci
ADD Email nvarchar(100) NOT NULL;
GO

ALTER TABLE Kupci
DROP COLUMN Telefon;
GO


CREATE TABLE #Squares
( NumberID int PRIMARY KEY,
  NumberSquared int
);
GO

DROP TABLE Kupci
GO

CREATE TABLE Kupci
( KupacID int IDENTITY(1,1) PRIMARY KEY,
  Prezime nvarchar(30) NOT NULL,
  Ime nvarchar(30) NOT NULL, 
  Telefon nvarchar (30) NULL,
  DatumRodjenja date NOT NULL,
  GodinaRodjenja AS DATEPART (year, DatumRodjenja) PERSISTED
);

DROP TABLE Kupci
GO

CREATE TABLE Kupci
( KupacID int IDENTITY(1,1) CONSTRAINT PK_Kupac PRIMARY KEY,
  Prezime nvarchar(30) NOT NULL,
  Ime nvarchar(30) NOT NULL, 
  Telefon nvarchar (30) NULL,
  DatumRodjenja date NOT NULL,
  GodinaRodjenja AS DATEPART (year, DatumRodjenja) PERSISTED
);

DROP TABLE Kupci
GO

CREATE TABLE Kupci
( KupacID int IDENTITY(1,1) CONSTRAINT PK_Kupac PRIMARY KEY,
  Prezime nvarchar(30) NOT NULL,
  Ime nvarchar(30) NOT NULL, 
  Telefon nvarchar (30) NULL,
  Email nvarchar (100) NOT NULL CONSTRAINT UQ_Email UNIQUE,
  DatumRodjenja date NOT NULL,
  GodinaRodjenja AS DATEPART (year, DatumRodjenja) PERSISTED
);

DROP TABLE Kupci
GO

CREATE TABLE Gradovi
( GradID int IDENTity(1,1) CONSTRAINT PK_Grad PRIMARY KEY,
  Naziv nvarchar(100)
)
GO

CREATE TABLE Kupci
( KupacID int IDENTITY(1,1) CONSTRAINT PK_Kupac PRIMARY KEY,
  Prezime nvarchar(30) NOT NULL,
  Ime nvarchar(30) NOT NULL, 
  Telefon nvarchar (30) NULL,
  Email nvarchar (100) NOT NULL CONSTRAINT UQ_Email UNIQUE,
  DatumRodjenja date NOT NULL,
  GradID int NOT NULL CONSTRAINT FK_Kupac_Gradovi FOREIGN KEY REFERENCES Gradovi (GradID),
  GodinaRodjenja AS DATEPART (year, DatumRodjenja) PERSISTED
);

