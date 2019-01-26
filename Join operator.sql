USE NORTHWND
GO

--1.	Prikazati sve kupce koji dolaze iz Njemačke ili Švedske, a imaju unesen fax.



--POLAZNIK

SELECT *
FROM Customers
WHERE Country LIKE 'Germany' OR Country LIKE 'Sweden' AND Fax IS NOT NULL

-- ISPRAVNO

SELECT *
FROM Customers
WHERE (Country = 'Germany' OR Country = 'Sweden') AND Fax IS NOT NULL 
-- U tekstu zadatka kaze da i kupci iz njemacke ili švedske moraju imati unesen faks (oba)
-- Ne koristimo LIKE jer radimo jednostavno poređenje teksta (bez patterna i sl.)

-- NAJBOLJE

SELECT *
FROM Customers
WHERE Country IN ('Germany', 'Sweden') AND Fax IS NOT NULL 

-- Korištenje IN operator u ovom slučaju pomaže da ne dupliciramo kod jer prima listu vrijednosti





--2.	Prikazati kupce kojima CompanyName počinje slovom 'M' ili ContactName počinje slovom 'M'.


SELECT CompanyName, ContactName
FROM Customers
WHERE CompanyName LIKE 'M%' OR ContactName LIKE 'M%'

-- Ovaj ste svi dobro uradili




--3.	Prikazati sve narudžbe koje su obavljene u 7 mjesecu 1997 godine.


SELECT *
FROM Orders
WHERE OrderDate >='1997-07-01' AND OrderDate <='1997-07-31'


SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 7


-- Ovaj ste svi dobro uradili na svoje načine
-- Prva verzija je domišljata, čak će ovaj prvi slučaj i raditi neznatno brže jer nema konverzije tipova podataka.
-- Cilj je bilo provjeriti poznavanje funkcija za rad sa datumima, tako da je se drugo riješenje očekivalo.


--4.	Prikazati sve proizvode koji su skuplji od 20 KM.


-- POLAZNIK

SELECT *
FROM Orders
WHERE Freight>20 -- Freight nije cijena proizvoda već taksa, proizvodi su Products

-- ISPRAVNO

SELECT ProductName, UnitPrice
FROM Products
Where UnitPrice > 20



--5.	Koliko je svaki zaposlenik uradio narudžbi?


SELECT EmployeeID, COUNT(OrderID) AS 'Broj narudzbi'
FROM Orders
GROUP BY EmployeeID
-- Ispišimo još ime i prezime uposlenog


-- ISPRAVNO

SELECT LastName AS [Prezime], FirstName AS [Ime], COUNT(T2.EmployeeID)
FROM Employees  AS T1
JOIN Orders		AS T2 ON T1.EmployeeID = T2.EmployeeID
GROUP BY T1.LastName, T1.FirstName
ORDER BY COUNT(T2.EmployeeID) DESC



--6.	Prikazati 5 kupaca koji su imali najviše narudžbi.


-- Radite Count po OrderID, on označava narudzbu - ne CustomerID
-- Rezultat jeste isti, ali je bolje zbog jasnoće koda

SELECT TOP 5 ContactName AS [KontaktIme], COUNT(T2.OrderID)
FROM Customers  AS T1
JOIN Orders		AS T2 ON T1.CustomerID = T2.CustomerID
GROUP BY T1.ContactName
ORDER BY COUNT(T2.CustomerID) DESC


--7.	Prikazati kupca koji je utrošio najviše novca u 7 mjesecu 1997. godine.


-- POLAZNIK

SELECT TOP 1 EmployeeID, Freight
FROM Orders
WHERE OrderDate >='1997-07-01' AND OrderDate <='1997-07-31'
ORDER BY 2 DESC
-- Freight nije cijena proizvoda već taksa


-- ISPRAVNO

SELECT TOP 1 ContactName AS [KontaktIme], SUM(T3.UnitPrice*T3.Quantity) AS [Najvise]
FROM Customers		 AS T1
JOIN Orders			 AS T2 ON T1.CustomerID=T2.CustomerID
JOIN [Order Details] AS T3 ON T2.OrderID=T3.OrderID
WHERE YEAR(T2.OrderDate) = 1997 AND MONTH(T2.OrderDate) = 7
GROUP BY T1.ContactName
ORDER BY [Najvise] DESC 
-- Nemojte zaboraviti ORDER BY
-- Komanda TOP najviše ima smisla u kombinaciji sa ORDER BY



--8.	Prikazati navjernijeg kupca koji dolazi iz Njemačke. Najvjerniji kupac je onaj koji je utrošio najviše novca.


-- ISPRAVNO

SELECT TOP 1 T1.ContactName AS [KontaktIme], T1.Country AS [Drzava], SUM(T3.UnitPrice*T3.Quantity) AS [Ukupno]
FROM Customers		 AS T1
JOIN Orders			 AS T2 ON T1.CustomerID = T2.CustomerID
JOIN [Order Details] AS T3 ON T2.OrderID = T3.OrderID
WHERE T1.Country = 'Germany'
GROUP BY T1.ContactName, T1.Country
ORDER BY [Ukupno] DESC

-- Najvjerniji kupac je jedan. 
-- Kao što u tekstu kaže on je utrošio najviše novca, što znači da moramo sortirati opadajući po ukupnom iznosu i uzeti prvog.
-- U prevodu : Nemojte zaboraviti ORDER BY i TOP u kominaciji



--9.	Prikazati dobavljače koji dolaze iz Japana i ukupan broj proizvoda koji se naručuje od njih.


-- POLAZNIK

SELECT CompanyName -- ukupan broj proizvoda?
FROM Suppliers 
WHERE Country LIKE 'Japan'

-- POLAZNIK

SELECT T1.ContactName AS [KontaktIme], SUM(T2.UnitsOnOrder) AS [Narudzbe] -- broj proizvoda (products) ?
FROM Suppliers AS T1
JOIN Products AS T2 ON T1.SupplierID=T2.SupplierID
WHERE T1.Country LIKE 'Japan'
GROUP BY T1.ContactName
ORDER BY 2 DESC



-- ISPRAVNO


SELECT T1.ContactName AS [Kontakt ime], COUNT(T2.ProductID) AS [Broj proizvoda]
FROM Suppliers AS T1
JOIN Products  AS T2 ON T1.SupplierID = T2.SupplierID
WHERE T1.Country = 'Japan' -- jednostavni operator poređenja (ne radite sa pattern-ima u tekstu)
GROUP BY T1.ContactName
ORDER BY 2 DESC




--10.	Kreirati upit koji nam prikazuje kategorije proizvoda i proizvode zajedno sa cijenom pojedinog proizvoda po komadu. 
--	    Uslovi su: kategorija proizvoda u svome nazivu posjeduje dio rijeći „food“ ili ime proizvoda počinje sa slovom T. 
--		Takoðer, cijena proizvoda po komadu treba biti veća od 60.


-- POLAZNIK

SELECT C.CategoryName, P.ProductName -- cijena proizvoda po komadu?
FROM Products AS P INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID
WHERE P.ProductName LIKE 'T%' AND P.UnitPrice>60 AND C.CategoryName LIKE '%food%'


-- ISPRAVNO

SELECT T1.CategoryName AS [ImeKategorije], T2.ProductName AS [ImeProizvoda], T2.UnitPrice AS [CijenaProizvoda]
FROM Categories AS T1
JOIN Products	AS T2 ON T1.CategoryID = T2.CategoryID 
WHERE (T1.CategoryName LIKE '%food%' OR T2.ProductName LIKE 'T%') AND T2.UnitPrice > 60


--11.	Kreirati upit koji će prikazati proizvode koji pripadaju kategoriji „Confections“. 
--		Takoðer, upit treba da prikaže podatke o dobavljaču: naziv dobavljača, adresa i broj telefona. 
--		Uslovi koji se trebaju zadovoljiti su:
--		a)	Stanje proizvoda na zalihama manje od 30 komada, i
--		b)	Dobavljač dolazi iz Manchestera ili Berlina. 


-- POLAZNIK


SELECT C.CategoryName, P.UnitsInStock, S.City
FROM Categories AS C 
INNER JOIN Products AS P ON C.CategoryID=P.CategoryID 
INNER JOIN Suppliers AS S ON P.SupplierID=S.SupplierID
WHERE C.CategoryName = 'Confections' AND P.UnitsInStock < 30 AND S.City = 'Manchester' OR S.City = 'Berlin'


-- ISPRAVNO


SELECT T1.CategoryName AS [ImeKategorije], T3.CompanyName AS [NazivDobavljaca], T3.[Address] AS [Adresa],T3.Phone AS [BrojTelefona],
T2.UnitsInStock AS [NaStanju], T3.City AS [Grad]
FROM Categories AS T1
JOIN Products AS T2 ON T1.CategoryID=T2.CategoryID
JOIN Suppliers AS T3 ON T2.SupplierID=T3.SupplierID
WHERE T1.CategoryName LIKE 'Confections' AND T2.UnitsInStock < 30 AND (T3.City LIKE 'Berlin' OR T3.City LIKE 'Manchester')


-- NAJBOLJE


SELECT T1.CategoryName AS [ImeKategorije], T3.CompanyName AS [NazivDobavljaca], T3.[Address] AS [Adresa],T3.Phone AS [BrojTelefona],
T2.UnitsInStock AS [NaStanju], T3.City AS [Grad]
FROM Categories AS T1
JOIN Products AS T2 ON T1.CategoryID=T2.CategoryID
JOIN Suppliers AS T3 ON T2.SupplierID=T3.SupplierID
WHERE T1.CategoryName = 'Confections' AND T2.UnitsInStock < 30 AND T3.City IN ('Berlin', 'Manchester')
-- IN operator
-- LIKE ide kod pattern-a
-- operator = za jednostavna poređenja



--12.	Kreirati upit koji prikazuje ukupan iznos popusta koji je dat za svaki pojedini proizvod.


-- POLAZNIK


SELECT ProductID, COUNT(Discontinued) AS 'Iznos popusta'
FROM Products
GROUP BY ProductID


-- ISPRAVNO


SELECT T1.ProductName AS [ImeProizvoda], SUM(ROUND(T2.UnitPrice*T2.Quantity*T2.Discount, 2)) AS [UkupanPopust]
FROM Products			AS T1 
JOIN [Order Details]	AS T2 ON T1.ProductID=T2.ProductID
GROUP BY T1.ProductName
ORDER BY 2 DESC



--13.	Prikazati ime i prezime zaposlenika (spojeno), te broj narudžbi koje su napravili. Uslovi su sljedeći:
--		a)	Zaposlenici dolaze iz Londona, ili
--		b)	Broj narudžbi manji od 100.


-- Svi su ovaj zadatak ispravno uradili

-- ISPRAVNO

SELECT E.LastName + ' ' + E.FirstName AS 'Prezime i ime zaposlenika',  COUNT(O.OrderID) AS 'Broj narudzbi'
FROM Employees	AS E 
JOIN Orders		AS O ON E.EmployeeID = O.EmployeeID
WHERE E.City = 'London' 
GROUP BY E.LastName, E.FirstName
HAVING COUNT(O.OrderID) < 100
ORDER BY 2 DESC