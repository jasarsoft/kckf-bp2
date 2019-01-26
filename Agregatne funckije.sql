/*
1.	Prikazati 5 kupaca koji su imali najviše narudžbi.
2.	Prikazati  narudzbu koja je koštala najviše novca u 7 mjesecu 1997. godine.
3.	Prikazati 10 navjernijih kupaca. Najvjerniji kupaci su oni koji su utrošili najviše novca.
4.	Prikazati proizvode koji imaju pojedinacnu cijenu izmeðu 10 i 50 a prodavani su u 1997 godini.
Iz naziva proizvoda ukloniti 2 zadnja karaktera.
5.	Kreirati upit koji nam prikazuje kategorije proizvoda i ukupan broj proizvoda te kategorije. U nazivu kategorije izmjeniti dio teksta 'ai' u 'cai'.
6.	Kreirati upit koji æe prikazati 5 narudzbi koje imaju brojèano najviše razlièitih proizvoda, ispisati datum narudzbe u formatu dd.mm.yyyy.
7.	Kreirati upit koji prikazuje zaposlenika sa najduzim imenom i prezimenom (ime+ „ “ + prezime).
*/

USE NORTHWND
GO

-- 1.	Prikazati 5 kupaca koji su imali najviše narudžbi.
SELECT TOP 5 C.ContactName,
	COUNT(O.OrderID) AS "Broj narudzbi"
FROM Customers AS C
	JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.ContactName
ORDER BY [Broj narudzbi] DESC


-- 2.	Prikazati  narudzbu koja je koštala najviše novca u 7 mjesecu 1997. godine.
SELECT TOP 1 O.OrderID, SUM(OD.UnitPrice * OD.Quantity) AS "Cijena narudzbe"
FROM Orders AS O 
	JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE MONTH(O.OrderDate) = 7 AND YEAR(O.OrderDate) = 1997
GROUP BY O.OrderID
ORDER BY [Cijena narudzbe] DESC


-- 3.	Prikazati 10 navjernijih kupaca. Najvjerniji kupaci su oni koji su utrošili najviše novca.
SELECT TOP 10 C.CompanyName, 
	SUM(OD.UnitPrice * OD.Quantity) AS "Kolicina"
FROM Customers AS C 
	JOIN Orders AS O 
		ON C.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD 
		ON O.OrderID = OD.OrderID
GROUP BY C.CompanyName
ORDER BY [Kolicina] DESC


-- 4.	Prikazati proizvode koji imaju pojedinacnu cijenu izmeðu 10 i 50 a prodavani su u 1997 godini.
SELECT P.ProductName, OD.UnitPrice, 
	CONVERT(nvarchar, O.OrderDate, 104)
FROM Products AS P 
	JOIN [Order Details] AS OD
		ON P.ProductID = OD.ProductID
	JOIN Orders AS O
		ON O.OrderID = OD.OrderID
WHERE (P.UnitPrice BETWEEN 10 AND 50) 
	AND YEAR(O.OrderDate) = 1997


-- 5.	Kreirati upit koji nam prikazuje kategorije proizvoda i ukupan broj proizvoda te kategorije. 
--		U nazivu kategorije izmjeniti dio teksta 'ai' u 'cai'.
SELECT C.CategoryName,
	REPLACE(C.CategoryName, 'ai', 'cai') AS "Izmjenjen naziv",
	COUNT(P.ProductID) AS "Broj prozivoda"
FROM Categories AS C
	JOIN Products AS P
		ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName
ORDER BY [Broj prozivoda] DESC


-- 6.	Kreirati upit koji æe prikazati 5 narudzbi koje imaju brojèano najviše razlièitih proizvoda, 
--		ispisati datum narudzbe u formatu dd.mm.yyyy.
SELECT TOP 5 OD.OrderID,
	COUNT(ProductID) AS "Broj proizvoda",
	CONVERT(NVARCHAR, O.OrderDate, 104) AS "Datum narudzbe"
FROM [Order Details] AS OD
	JOIN Orders AS O
		ON O.OrderID = OD.OrderID
GROUP BY OD.OrderID, O.OrderDate
ORDER BY [Broj proizvoda] DESC


-- 7.	Kreirati upit koji prikazuje zaposlenika sa najduzim imenom i prezimenom (ime+ „ “ + prezime).
SELECT TOP 1 E.FirstName + ' ' + E.LastName AS "Ime i prezime",
	LEN(E.FirstName + ' ' + E.LastName) AS "Duzina imena"
FROM Employees AS E
ORDER BY [Duzina imena] DESC
