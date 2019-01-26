-- Maksimalna cijena proizvoda
USE NORTHWND
SELECT MIN(UnitPrice) AS 'Minimalna cijena', MAX(UnitPrice) AS 'Maksimalna cijena'
FROM Products

-- Kako mo�emo testirati?

-- Prosje�na cijena
SELECT AVG(UnitPrice) AS 'Prosje�na cijena'
FROM Products

SELECT SUM(Quantity) AS 'Ukupna koli�ina'
FROM [Order Details]
WHERE ProductID = 15

SELECT * FROM [Order Details]

-- Prebrojavanje redova, zapisa
SELECT COUNT(*) AS 'Broj dobavlja�a'
FROM Suppliers

SELECT * FROM Suppliers WHERE Fax IS NOT NULL

-- Uzima u obzir NULL vrijednost
SELECT COUNT(Fax) AS 'Broj dobavlja�a koji imaju unesen fax'
FROM Suppliers

-- Sa ISNULL mo�emo ispraviti rezultat
SELECT COUNT(ISNULL(Fax, 'N/A'))
FROM Suppliers

-- Agregatne funkcije i uslov WHERE
SELECT SUM(Quantity) AS 'Ukupno prodano'
FROM [Order Details]
WHERE ProductID IN (50, 51, 52)

-- Agregatne funkcije i uslov HAVING
SELECT SUM(Quantity) AS 'Ukupno prodano'
FROM [Order Details]
WHERE SUM(Quantity) > 200 -- HAVING

-- Kombinacija WHERE I HAVING
SELECT SUM(Quantity) AS 'Ukupno prodano'
FROM [Order Details]
WHERE ProductID IN (50, 60, 70)
HAVING SUM(Quantity) > 200

-- Kori�tenje GROUP BY
SELECT ProductID, SUM(Quantity) AS 'Ukupno prodano'
FROM [Order Details]
GROUP BY ProductID
ORDER BY 2 DESC

-- Kori�tenje GROUP BY sa HAVING klauzulom
SELECT ProductID, SUM(Quantity) AS 'Ukupno prodano'
FROM [Order Details] 
GROUP BY ProductID
HAVING SUM(Quantity) > 1000
ORDER BY [Ukupno prodano] DESC

-- Kombinacija WHERE i HAVING
SELECT ProductID, SUM(Quantity) AS 'Ukupno prodano'
FROM [Order Details] 
WHERE ProductID IN (16, 17, 56, 60) -- U listu dodati i ProductID 17 gdje je koli�ina ispod 1000 kom.
GROUP BY ProductID
HAVING SUM(Quantity) > 1000
ORDER BY 2 DESC
