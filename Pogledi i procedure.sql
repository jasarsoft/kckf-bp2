use northwnd;

CREATE VIEW vw_Employees_SelectOrderCountTotalPaymentEJ
AS
	SELECT	E.FirstName + ' ' + E.LastName, 
			COUNT(OD.OrderID) AS "Broj narudbi",
			SUM(OD.UnitPrice * OD.Quantity) AS "Ukupna zarada"
	FROM Employees AS E 
		INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	GROUP BY E.FirstName, E.LastName

SELECT * FROM vw_Employees_SelectOrderCountTotalPaymentEJ

SELECT * FROM Employees;
SELECT * FROM Orders
SELECT * FROM [Order Details]

ALTER VIEW vw_Employees_SelectOrderCountTotalPaymentEJ
AS
	SELECT	E.FirstName, E.LastName,			
			COUNT(OD.OrderID) AS "Broj narudbi",
			SUM(OD.UnitPrice * OD.Quantity) AS "Ukupna zarada"
	FROM Employees AS E 
		INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE YEAR(O.OrderDate) = 1997
	GROUP BY E.FirstName, E.LastName

SELECT * FROM vw_Employees_SelectOrderCountTotalPaymentEJ

CREATE PROCEDURE proc_EdinJasarevic
	@YEAR int
AS
	SELECT	E.FirstName, E.LastName,			
			COUNT(OD.OrderID) AS "Broj narudbi",
			SUM(OD.UnitPrice * OD.Quantity) AS "Ukupna zarada"
	FROM Employees AS E 
		INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE YEAR(O.OrderDate) = @YEAR
	GROUP BY E.FirstName, E.LastName

EXECUTE proc_EdinJasarevic 1997

CREATE TRIGGER tr_EdinJasarevic_v11
ON Suppliers
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'Odbi'
	ROLLBACK;
END

DROP TRIGGER NeBrisiSupl
DROP TRIGGER tr_EdinJasarevic_v11


ALTER PROCEDURE proc_EdinJasarevic_Suppliers
	@Grad NVARCHAR(100)
AS
BEGIN
	SELECT ProductName AS "Ime prozivoda"
	FROM Products AS P
	INNER JOIN Suppliers AS S ON P.SupplierID = S.SupplierID
	WHERE S.City LIKE @Grad
END

EXECUTE proc_EdinJasarevic_Suppliers 'Berlin'