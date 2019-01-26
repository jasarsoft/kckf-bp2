--Animal dating site

CREATE TABLE Species
(
	SpeciesID		INT		PRIMARY KEY IDENTITY,
	Species			NVARCHAR(50)	NOT NULL UNIQUE,
	FriendlyName		NVARCHAR(50)	NOT NULL
);

CREATE TABLE Animals
(
 AnimalID		INT		PRIMARY KEY IDENTITY,
 [Name]			NVARCHAR(50)	NOT NULL,
 Species		INT		NOT NULL REFERENCES Species(SpeciesID),
 ContactEmail		NVARCHAR(50)	NOT NULL UNIQUE
);


--column-level constraints

CREATE TABLE Interests
(
	 AnimalID	INT		NOT NULL REFERENCES		Animals(AnimalID),
	 SpeciesID	INT		NOT NULL REFERENCES		Species(SpeciesID)
);


--table-level constraint
--add the constraint as if it's another column:

CREATE TABLE Interests
(
	AnimalID	INT		NOT NULL REFERENCES  Animals(AnimalID),
	SpeciesID 	INT		NOT NULL REFERENCES Species(SpeciesID),
	PRIMARY KEY (AnimalID, SpeciesID)
);


--CONSTRAINT FK_Interests_AnimalID FOREIGN KEY (AnimalID) REFERENCES Animals(AnimalID)