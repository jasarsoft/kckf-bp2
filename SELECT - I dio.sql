-- Jednostavan SELECT sa listom kolona
USE NORTHWND -- Svi naredni upiti su nad istom bazom podataka
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees

-- Prethodni upit proširen WHERE klauzulom
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE EmployeeID = 1

-- Poreðenje stringova
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE Country = 'USA'

-- Poreðenje stringova koristeæi operator LIKE i wildcard karakter %
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE Title LIKE '%Manager%' -- Obavlja bilo koju ulogu menadžera tj. bilo gdje u rijeèi sadrži 'Manager'

-- Poreðenje stringova koristeæi wildcard karaktere %, [^]
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE Title LIKE '[^IV]%e' -- Ne poèinje slovima 'I' ili 'V', a završava slovom 'e'

-- Poreðenje datuma
SELECT EmployeeID, FirstName, LastName, Title, HireDate
FROM Employees
WHERE HireDate <= '01.01.1994' -- Format je mm.dd.yyyy

-- Korištenje logièkih operatora AND i OR
SELECT ProductID, ProductName, SupplierID, UnitPrice
FROM Products
WHERE (ProductName LIKE 'T%' OR ProductID = 46) AND (UnitPrice > 16.00) -- Provjeriti rezultate upita bez zagrada

-- Korištenje BETWEEN operatora (opseg vrijednosti)
SELECT ProductID, ProductName, SupplierID, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 AND 20

-- Primjer prethodnog upita sa operatorima poreðenja
SELECT ProductID, ProductName, SupplierID, UnitPrice
FROM Products
WHERE UnitPrice >= 10 AND UnitPrice <= 20

-- Korištenje IN operatora (liste vrijednosti)
SELECT CompanyName, Country
FROM Suppliers
WHERE Country IN ('Japan', 'Italy')

-- Primjer prethodnog upita koristeæi LIKE operator za poreðenje stringova
SELECT CompanyName, Country
FROM Suppliers
WHERE Country LIKE 'Japan' OR Country LIKE 'Italy'

-- Provjera NULL vrijednosti
SELECT CompanyName, ContactName, Phone, Fax 
FROM Customers
WHERE FAX IS NULL -- Fax nije unesen. Suprotno je IS NOT NULL

-- Korištenje funkcije ISNULL (formatira izlaz NULL vrijednosti)
SELECT CompanyName, ContactName, Phone, ISNULL(Fax, 'N/A') AS "Fax" -- Ako je Fax NULL, ispiši 'N/A'
FROM Customers




