-- Sortiranje podataka
USE NORTHWND
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
ORDER BY LastName -- ASC/DESC

-- Sortiranje podataka po više kolona
SELECT ProductName, CategoryID, UnitPrice
FROM Products
ORDER BY CategoryID ASC, UnitPrice DESC -- Sortiranje po redoslijedu kolone iz SELECT liste

-- Sortiranje podataka koristeći izraz
SELECT ProductName, CategoryID, UnitPrice * 1.1
FROM Products
ORDER BY 3 DESC

-- Izlistavanje tačno određenog broja zapisa
SELECT TOP 20 OrderID, ProductID, Quantity
FROM [Order Details]
ORDER BY 3 DESC

SELECT TOP 20 WITH TIES OrderID, ProductID, Quantity
FROM [Order Details]
ORDER BY 3 DESC

SELECT TOP 20 PERCENT OrderID, ProductID, Quantity
FROM [Order Details]
ORDER BY 3 DESC

-- Eliminisanje duplih redova
SELECT * FROM Suppliers

SELECT Country
FROM Suppliers
ORDER BY Country

SELECT DISTINCT Country
FROM Suppliers
ORDER BY Country

SELECT DISTINCT CompanyName, Country -- Probati sa ContactTitle kolonom
FROM Suppliers
ORDER BY Country

SELECT ContactTitle, Country -- Probati sa ContactTitle kolonom
FROM Suppliers
ORDER BY Country

SELECT DISTINCT ContactTitle, Country -- Probati sa ContactTitle kolonom
FROM Suppliers
ORDER BY Country

-- Korištenje aliasa
SELECT CategoryID AS 'ID katerogije', ProductName AS 'Naziv proizvoda', UnitPrice AS 'Cijena'
FROM Products

SELECT CategoryID AS "ID katerogije", ProductName AS [Naziv proizvoda], UnitPrice Cijena
FROM Products
ORDER BY Cijena DESC

SELECT DISTINCT C.CategoryName AS 'Naziv kategorije', P.ProductName AS [Naziv proizvoda], P.UnitPrice Cijena
FROM Products AS P INNER JOIN Categories AS C
	ON P.CategoryID = C.CategoryID
ORDER BY Cijena DESC

-- Korištenje literala
SELECT 'Cijena proizvoda', ProductName, 'je', UnitPrice, 'KM'
FROM Products

-- Korištenje izraza
SELECT ProductName AS 'Naziv proizvoda', UnitPrice * 1.1 AS 'Cijena uvećana za 10%'
FROM Products
WHERE UnitPrice * 1.1 > 120
ORDER BY UnitPrice * 1.1 DESC

-- Funkcije za rad sa stringovima
SELECT FirstName, LastName, LEFT(FirstName, 3), RIGHT (LastName, 3)
FROM Employees

SELECT FirstName, LastName, LOWER(FirstName) AS Ime, UPPER (LastName) AS Prezime
FROM Employees

SELECT Title, SUBSTRING(Title, 1, 5) AS 'Prvih pet karaktera iz kolone Title'
FROM Employees

SELECT FirstName, LastName, Address, REPLACE(Address, '-', '/') AS "Zamjenjena adresa"
FROM Employees
WHERE Address LIKE '%-%'

SELECT FirstName, LastName, Address, CHARINDEX('-', Address) AS "Lokacija indexa"
FROM Employees
WHERE CHARINDEX('-', Address) <> 0

SELECT FirstName, LastName, Address, SUBSTRING(Address, 0, CHARINDEX('-', Address)) 
FROM Employees
WHERE CHARINDEX('-', Address) <> 0

-- Matematičke funkcije
SELECT RAND()

-- SELECT ROUND(RAND()*100, 0) -- Vrijednost od 0 - 100

SELECT PI()

SELECT POWER(2, 4)

SELECT SQRT(10)

SELECT ROUND(123.4545, 2), ROUND(123.45, -2)

SELECT ProductName, UnitPrice, 
	ROUND(UnitPrice, 2)
FROM Products
ORDER BY UnitPrice DESC

-- Funkcije za rad sa datumima
SELECT GETDATE(), CURRENT_TIMESTAMP

SELECT FirstName, LastName, BirthDate, 
	DATEPART(YEAR, BirthDate) AS 'Godina rođenja'
FROM Employees

SELECT FirstName, LastName, BirthDate, 
	DATEDIFF(YEAR, BirthDate, GETDATE()) AS 'Starost'
FROM Employees

-- dodavanje dana na datum
DECLARE @StartDate date ='01.01.1998'
SELECT OrderID, CustomerID, OrderDate,
	@StartDate, DATEADD(DAY, 1, GETDATE())
FROM Orders
WHERE OrderDate BETWEEN @StartDate AND DATEADD(DAY, 1, GETDATE())

-- Spajanje kolona koristeći konverzije
SELECT 'Zaposlenik ' + FirstName + ' ' + LastName + ' je rođen ' + CONVERT(nvarchar, BirthDate, 104)
FROM Employees

USE NORTHWND
SELECT 'Zaposlenik ' + FirstName + ' ' + LastName + ' ima ID = ' + CAST(EmployeeID AS nvarchar)
FROM Employees

SELECT 'Zaposlenik ' + FirstName + ' ' + LastName + ' je rođen ' + CONVERT (nvarchar, BirthDate, 104) + 
	   ' i ima ' + CONVERT(nvarchar, DATEDIFF(YEAR, BirthDate, GETDATE())) + ' godina.'
FROM Employees








