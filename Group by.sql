USE NORTHWND
--1
--Prikazati proizvode čiji naziv počinje slovima „C“ ili „G“, drugo slovo može biti bilo koje,
--a treće slovo u nazivu je „A“ ili „O“.
 
SELECT P.ProductID, P.ProductName
FROM Products AS P
WHERE P.ProductName LIKE '[CG]_[AO]%'
ORDER BY P.ProductName

--2
--Prikazati listu proizvoda čiji naziv počinje slovima „L“ ili  „T“, ili je ID proizvoda = 46.
--Lista treba da sadrži samo one proizvode čija je se cijena po komadu kreće između 10 i 50. Upit napisati na dva načina.
 
SELECT P.ProductID, P.ProductName, P.UnitPrice
FROM Products AS P
WHERE (P.ProductName LIKE '[LT]%' OR P.ProductID = 46) AND P.UnitPrice BETWEEN 10 AND 50
ORDER BY UnitPrice DESC
 
SELECT P.ProductID, P.ProductName, P.UnitPrice
FROM Products AS P
WHERE (P.ProductName LIKE '[LT]%' OR P.ProductID = 46) AND (P.UnitPrice >= 10 AND P.UnitPrice <= 50)
ORDER BY UnitPrice DESC

--3
--Prikazati naziv proizvoda i cijenu gdje je stanje na zalihama manje od naručene količine.
--Također, u rezultate upita uključiti razliku između naručene količine i stanja zaliha.
 
SELECT P.ProductID, P.ProductName, P.UnitPrice, P.UnitsInStock, P.UnitsOnOrder, (P.UnitsOnOrder - P.UnitsInStock) AS Razlika
FROM Products AS P
WHERE P.UnitsInStock < P.UnitsOnOrder
ORDER BY Razlika DESC

--4
--Prikazati kupca koji je napravio narudzbu koja je koštala najviše novca (bez popusta) u 7 mjesecu 1997. godine.

SELECT TOP 1 C.CompanyName, SUM(OD.UnitPrice * OD.Quantity) AS [Iznos]
FROM Orders AS O
	 JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	 JOIN [Customers] AS C ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 7
GROUP BY C.CompanyName
ORDER BY Iznos DESC

--5
--Prikazati 10 navjernijih kupaca. Najvjerniji kupaci su oni koji su utrošili najviše novca.

SELECT TOP 10 C.CompanyName, ROUND(SUM((OD.UnitPrice * OD.Quantity) * (1 - OD.Discount)), 2) AS [Iznos]
FROM Customers AS C
	 JOIN Orders AS O ON C.CustomerID = O.CustomerID
	 JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY C.CompanyName
ORDER BY Iznos DESC

--6
--Prikazati proizvode koji imaju pojedinacnu cijenu između 10 i 50 a prodavani su u 1997 godini.
--U sklopu rezltata upita vratiti samo poizvode koji se nalaze na više od 20 narudžbi. Iz naziva proizvoda ukloniti 4 zadnja karaktera.

SELECT LEFT(P.ProductName, LEN(P.ProductName) - 4) AS [ProductName], P.UnitPrice
FROM Products AS P
	 JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	 JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE P.UnitPrice BETWEEN 10 AND 50 AND YEAR(O.OrderDate) = 1997
GROUP BY P.ProductName, P.UnitPrice
HAVING COUNT(O.OrderID) > 20
ORDER BY P.UnitPrice DESC

--7
--Kreirati upit koji nam prikazuje kategorije proizvoda i ukupan broj proizvoda te kategorije. 
--U nazivu kategorije izmjeniti dio teksta 'ai' u 'cai'.

SELECT REPLACE(C.CategoryName, 'uc', 'ea') AS [CategoryName], COUNT(P.ProductID) AS [Total]
FROM Categories AS C
	 JOIN Products AS P ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName
ORDER BY Total DESC

--8
--Kreirati upit koji će prikazati 3 narudzbe koje imaju brojčano najviše različitih proizvoda, ispisati datum narudzbe u formatu dd.mm.yyyy.
--Omogučiti da se ispisu narudzbe koje imaju isti broj različitih proizvoda na računu kao posljednji treci u listi.

SELECT TOP 3 WITH TIES CONVERT(nvarchar, O.OrderDate, 104) AS [Date], COUNT(OD.ProductID) AS [ProductCount]
FROM Orders AS O
	 JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY OD.OrderID, O.OrderDate
ORDER BY [ProductCount] DESC

--9
--Kreirati upit koji prikazuje zaposlenika sa najduzim imenom i prezimenom (ime+ „ “ + prezime).

SELECT TOP 5 E.FirstName + ' ' + E.LastName AS [FirstLastName], LEN(E.FirstName + ' ' + E.LastName) AS [Length]
FROM Employees AS E
ORDER BY LEN(E.FirstName + ' ' + E.LastName) DESC

--10
--Prikazati kupce koji nisu napravili niti jednu narudžbu.

SELECT C.CompanyName, COUNT(O.OrderID) AS [BrojNarudzbi]
FROM Customers AS C
	 LEFT JOIN [Orders] AS O ON C.CustomerID = O.CustomerID
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) = 0

--11
--Prikazati sve dostavljače zajedno sa brojem narudžbi koje su obavili sa zakašnjenjem, odnosno, datum dostave je veći od datuma do kojeg je zahtjevana narudžba.

SELECT S.CompanyName, COUNT(O.OrderID) AS [Total]
FROM Shippers AS S
	 JOIN Orders AS O ON S.ShipperID = O.ShipVia
WHERE ShippedDate > RequiredDate
GROUP BY S.CompanyName
ORDER BY Total DESC

--12
--Kako se zove i odakle dolazi direktor odnosno sef poslovnice? Koliko je narudzbi obradio do sada i koliko iznosi ukupana zarada od tih narudzbi?
--Ukupnu zaradu zaokruziti na dvije decimale.
--Dodati kolonu koja prikazuje isto (iznos ukupne zarade) ali na kraju dodati valutu 'KM', obratiti paznju na broj decimala u iznosu.

SELECT E.FirstName, E.LastName, E.City, E.Country, COUNT(DISTINCT O.OrderID) AS [OrderCount], CAST(CAST(SUM((OD.UnitPrice * OD.Quantity) - (1 - OD.Discount)) AS decimal(18, 2)) AS nvarchar) + ' KM' AS [Total]
FROM Employees AS E
	 JOIN [Orders] AS O ON E.EmployeeID = O.EmployeeID
	 JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE ReportsTo IS NULL
GROUP BY E.FirstName, E.LastName, E.City, E.Country