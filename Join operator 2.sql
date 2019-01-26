/*
1.	Prikazati sve kupce koji dolaze iz Njemačke ili Švedske, a imaju unesen fax.
2.	Prikazati kupce kojima CompanyName počinje slovom 'M' ili ContactName počinje slovom 'M'.
3.	Prikazati sve narudžbe koje su obavljene u 7 mjesecu 1997 godine.
4.	Prikazati sve proizvode koji su skuplji od 20 KM.
5.	Koliko je svaki zaposlenik uradio narudžbi?
6.	Prikazati 5 kupaca koji su imali najviše narudžbi.
7.	Prikazati kupca koji je utrošio najviše novca u 7 mjesecu 1997. godine.
8.	Prikazati navjernijeg kupca koji dolazi iz Njemačke. Najvjerniji kupac je onaj koji je utrošio najviše novca.
9.	Prikazati dobavljaèe koji dolaze iz Japana i ukupan broj proizvoda koji se naručuje od njih.
10.	Kreirati upit koji nam prikazuje kategorije proizvoda i proizvode zajedno sa cijenom pojedinog proizvoda po komadu. Uslovi su: kategorija proizvoda u svome nazivu posjeduje dio rijeći „food“ ili ime proizvoda počinje sa slovom T. Takoðer, cijena proizvoda po komadu treba biti veća od 60.
11.	Kreirati upit koji će prikazati proizvode koji pripadaju kategoriji „Confections“. Takoðer, upit treba da prikaže podatke o dobavljaču: naziv dobavljača, adresa i broj telefona. Uslovi koji se trebaju zadovoljiti su:
a)	Stanje proizvoda na zalihama manje od 30 komada, i
b)	Dobavljač dolazi iz Manchestera ili Berlina. 
12.	Kreirati upit koji prikazuje ukupan iznos popusta koji je dat za svaki pojedini proizvod.
13.	Prikazati ime i prezime zaposlenika (spojeno), te broj narudžbi koje su napravili. Uslovi su sljedeći:
a)	Zaposlenici dolaze iz Londona, ili
b)	Broj narudžbi manji od 100.
*/

USE NORTHWND;

-- 1.	Prikazati sve kupce koji dolaze iz Njemačke ili Švedske, a imaju unesen fax.
SELECT CompanyName, Country
FROM Customers
WHERE Country IN ('Sweden', 'Germany')


-- 2.	Prikazati kupce kojima CompanyName počinje slovom 'M' ili ContactName počinje slovom 'M'.
SELECT CompanyName, ContactName
FROM Customers
WHERE CompanyName LIKE 'M%' OR ContactName LIKE 'M%'


-- 3.	Prikazati sve narudžbe koje su obavljene u 7 mjesecu 1997 godine.
SELECT OrderDate
FROM Orders
WHERE MONTH(OrderDate) = 7 AND YEAR(OrderDate) = 1997


-- 4.	Prikazati sve proizvode koji su skuplji od 20 KM.
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > 20


-- 5.	Koliko je svaki zaposlenik uradio narudžbi?
SELECT EmployeeID, COUNT(EmployeeID) AS "Broj narudbi"
FROM Orders
GROUP BY EmployeeID

SELECT E.FirstName, E.LastName, COUNT(O.EmployeeID) AS "Broj narudzbi"
FROM Employees AS E 
	JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName
ORDER BY [Broj narudzbi] DESC


-- 6.	Prikazati 5 kupaca koji su imali najviše narudžbi.
SELECT TOP 5 C.ContactName, COUNT(O.CustomerID) AS "Broj narudzbi"
FROM Customers AS C 
	JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.ContactName
ORDER BY [Broj narudzbi] DESC


-- 7.	Prikazati kupca koji je utrošio najviše novca u 7 mjesecu 1997. godine.
SELECT TOP 1 C.ContactName, SUM(OD.UnitPrice * OD.Quantity) AS "Kolicina"
FROM Customers AS C
	JOIN Orders AS O ON C.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE MONTH(O.OrderDate) = 7 AND YEAR(O.OrderDate) = 1997
GROUP BY C.ContactName
ORDER BY [Kolicina] DESC


-- 8.	Prikazati navjernijeg kupca koji dolazi iz Njemačke. Najvjerniji kupac je onaj koji je utrošio najviše novca.
SELECT TOP 1 C.ContactName, C.Country, SUM(OD.UnitPrice * OD.Quantity) AS "Kolicina"
FROM Customers AS C
	JOIN Orders AS O ON C.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE C.Country = 'Germany'
GROUP BY C.ContactName, C.Country
ORDER BY [Kolicina] DESC


-- 9.	Prikazati dobavljace koji dolaze iz Japana i ukupan broj proizvoda koji se naručuje od njih.
SELECT S.CompanyName, 
	COUNT(P.SupplierID) AS "Broj proizvoda"
FROM Products AS P
	JOIN Suppliers AS S ON P.SupplierID = S.SupplierID
WHERE S.Country = 'Japan'
GROUP BY S.CompanyName


-- 10.	Kreirati upit koji nam prikazuje kategorije proizvoda i proizvode zajedno sa cijenom pojedinog proizvoda po komadu. 
--		Uslovi su: kategorija proizvoda u svome nazivu posjeduje dio rijeći „food“ ili ime proizvoda počinje sa slovom T. Takoðer, cijena proizvoda po komadu treba biti veća od 60.
SELECT C.CategoryName, P.ProductName, P.UnitPrice
FROM Categories AS C
	JOIN Products AS P ON C.CategoryID = P.CategoryID
WHERE (C.CategoryName LIKE '%food%' OR P.ProductName LIKE 'T%') AND P.UnitPrice > 60
ORDER BY P.UnitPrice DESC


-- 11.	Kreirati upit koji će prikazati proizvode koji pripadaju kategoriji „Confections“. 
--		Takodjer, upit treba da prikaže podatke o dobavljaču: naziv dobavljača, adresa i broj telefona. 
--		Uslovi koji se trebaju zadovoljiti su:
--			a)	Stanje proizvoda na zalihama manje od 30 komada, i
--			b)	Dobavljač dolazi iz Manchestera ili Berlina. 
SELECT S.CompanyName, S.Address, S.Phone,
	C.CategoryName, S.City,
	P.UnitsInStock
FROM Products AS P
	JOIN Categories AS C ON C.CategoryID = P.CategoryID
	JOIN Suppliers AS S ON S.SupplierID = P.SupplierID 
WHERE C.CategoryName = 'Confections' 
	AND P.UnitsInStock < 30
	AND S.City IN ('Manchester', 'Berlin')
	
-- 12.	Kreirati upit koji prikazuje ukupan iznos popusta koji je dat za svaki pojedini proizvod.
SELECT P.ProductName,
	SUM(ROUND(OD.UnitPrice * OD.Quantity  * OD.Discount, 2)) AS "UkupanPopust"
FROM Products AS P
	JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
ORDER BY [UkupanPopust] DESC


--	13.	Prikazati ime i prezime zaposlenika (spojeno), te broj narudžbi koje su napravili. Uslovi su sljedeći:
--		a)	Zaposlenici dolaze iz Londona, ili
--		b)	Broj narudžbi manji od 100.
SELECT E.FirstName + ' ' + E.LastName AS "Ime i prezime",
	COUNT(O.OrderID) AS "Broj narudzbi"
FROM Employees AS E
	JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE E.City = 'London'
GROUP BY E.FirstName + ' ' + E.LastName
HAVING COUNT(O.OrderID) < 100
ORDER BY [Broj narudzbi] DESC

