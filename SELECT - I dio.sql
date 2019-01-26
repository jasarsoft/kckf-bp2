-- Jednostavan SELECT sa listom kolona
USE NORTHWND -- Svi naredni upiti su nad istom bazom podataka
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees

-- Prethodni upit pro�iren WHERE klauzulom
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE EmployeeID = 1

-- Pore�enje stringova
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE Country = 'USA'

-- Pore�enje stringova koriste�i operator LIKE i wildcard karakter %
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE Title LIKE '%Manager%' -- Obavlja bilo koju ulogu menad�era tj. bilo gdje u rije�i sadr�i 'Manager'

-- Pore�enje stringova koriste�i wildcard karaktere %, [^]
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE Title LIKE '[^IV]%e' -- Ne po�inje slovima 'I' ili 'V', a zavr�ava slovom 'e'

-- Pore�enje datuma
SELECT EmployeeID, FirstName, LastName, Title, HireDate
FROM Employees
WHERE HireDate <= '01.01.1994' -- Format je mm.dd.yyyy

-- Kori�tenje logi�kih operatora AND i OR
SELECT ProductID, ProductName, SupplierID, UnitPrice
FROM Products
WHERE (ProductName LIKE 'T%' OR ProductID = 46) AND (UnitPrice > 16.00) -- Provjeriti rezultate upita bez zagrada

-- Kori�tenje BETWEEN operatora (opseg vrijednosti)
SELECT ProductID, ProductName, SupplierID, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 AND 20

-- Primjer prethodnog upita sa operatorima pore�enja
SELECT ProductID, ProductName, SupplierID, UnitPrice
FROM Products
WHERE UnitPrice >= 10 AND UnitPrice <= 20

-- Kori�tenje IN operatora (liste vrijednosti)
SELECT CompanyName, Country
FROM Suppliers
WHERE Country IN ('Japan', 'Italy')

-- Primjer prethodnog upita koriste�i LIKE operator za pore�enje stringova
SELECT CompanyName, Country
FROM Suppliers
WHERE Country LIKE 'Japan' OR Country LIKE 'Italy'

-- Provjera NULL vrijednosti
SELECT CompanyName, ContactName, Phone, Fax 
FROM Customers
WHERE FAX IS NULL -- Fax nije unesen. Suprotno je IS NOT NULL

-- Kori�tenje funkcije ISNULL (formatira izlaz NULL vrijednosti)
SELECT CompanyName, ContactName, Phone, ISNULL(Fax, 'N/A') AS "Fax" -- Ako je Fax NULL, ispi�i 'N/A'
FROM Customers




