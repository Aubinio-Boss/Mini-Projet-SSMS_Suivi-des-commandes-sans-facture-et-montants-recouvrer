USE WideWorldImporters
GO


SELECT TABLE_SCHEMA, TABLE_NAME
FROM [INFORMATION_SCHEMA].[TABLES]
WHERE [TABLE_TYPE] = 'Base Table'
ORDER BY TABLE_SCHEMA, TABLE_NAME




SELECT [COLUMN_NAME], [DATA_TYPE], [NUMERIC_PRECISION], [NUMERIC_SCALE]
FROM [INFORMATION_SCHEMA].[COLUMNS]
WHERE TABLE_SCHEMA = 'SALES' AND TABLE_NAME = 'INVOICES'
ORDER BY ORDINAL_POSITION




SELECT TOP (10) [InvoiceLineID] 
                ,[InvoiceID]
				,[Description]
				,[PackageTypeID]
				,[Quantity]
				,[UnitPrice]
				,[TaxRate]
				,[TaxAmount]
				,[LineProfit]
				,[ExtendedPrice]
FROM [Sales].[InvoiceLines]




SELECT A.CustomerId, C.CustomerName,
       COUNT(DISTINCT A.OrderId) AS TotalNBOrders,
       COUNT(DISTINCT A.InvoiceId) AS TotalNBInvoices,
       SUM(A.UnitPrice * A.Quantity) AS OrdersTotalValue,
       SUM(A.UnitPriceI * A.QuantityI) AS InvoicesTotalValue,
       ABS(SUM(A.UnitPrice * A.Quantity) - SUM(A.UnitPriceI * A.QuantityI)) AS AbsoluteValueDifference
FROM (
    SELECT O.CustomerID, O.OrderId, NULL AS InvoiceID, OL.UnitPrice, OL.Quantity, 0 AS UnitPriceI, 0 AS QuantityI
    FROM Sales.Orders AS O
    JOIN Sales.OrderLines AS OL ON O.OrderId = OL.OrderID
    WHERE EXISTS (
        SELECT 1 FROM Sales.Invoices AS II WHERE II.OrderID = O.OrderID
    )
    UNION
    SELECT I.CustomerID, NULL AS OrderId, I.InvoiceID, 0, 0, IL.UnitPrice, IL.Quantity
    FROM Sales.Invoices AS I
    JOIN Sales.InvoiceLines AS IL ON I.InvoiceID = IL.InvoiceID
) AS A
JOIN Sales.Customers AS C ON A.CustomerID = C.CustomerID
GROUP BY A.CustomerID, C.CustomerName
ORDER BY AbsoluteValueDifference DESC, TotalNBOrders, CustomerName




UPDATE Sales.InvoiceLines
SET UnitPrice = UnitPrice + 20
WHERE InvoiceLineID = (
    SELECT MIN(IL.InvoiceLineID)
    FROM Sales.Invoices AS I
    JOIN Sales.InvoiceLines AS IL ON I.InvoiceID = IL.InvoiceID
    WHERE I.CustomerID = 1060)




USE [WideWorldImporters];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[ReportCustomerTurnover]
    @Choice INT = 1,
    @Year   INT = 2013
AS
BEGIN
    SET NOCOUNT ON;

    IF @Choice = 1
    BEGIN
        SELECT 
            c.CustomerID,
            c.CustomerName,
            SUM(il.UnitPrice * il.Quantity) AS TotalTurnover
        FROM Sales.Customers    AS c
        JOIN Sales.Invoices     AS i  ON i.CustomerID    = c.CustomerID
        JOIN Sales.InvoiceLines AS il ON il.InvoiceID    = i.InvoiceID
        WHERE YEAR(i.InvoiceDate) = @Year
        GROUP BY c.CustomerID, c.CustomerName
        ORDER BY TotalTurnover DESC;
        RETURN;
    END

    IF @Choice = 2
    BEGIN
        SELECT
            MONTH(i.InvoiceDate)       AS InvoiceMonth,
            DATENAME(MONTH, i.InvoiceDate) AS MonthName,
            SUM(il.UnitPrice * il.Quantity) AS MonthlyTurnover
        FROM Sales.Invoices     AS i
        JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
        WHERE YEAR(i.InvoiceDate) = @Year
        GROUP BY MONTH(i.InvoiceDate), DATENAME(MONTH, i.InvoiceDate)
        ORDER BY MONTH(i.InvoiceDate);
        RETURN;
    END

    IF @Choice = 3
    BEGIN
        SELECT 
            c. [DeliveryCityID]   AS City,
            SUM(il.UnitPrice * il.Quantity) AS CountryTurnover
        FROM Sales.Customers    AS c
        JOIN Sales.Invoices     AS i  ON i.CustomerID = c.CustomerID
        JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
        WHERE YEAR(i.InvoiceDate) = @Year
        GROUP BY c.[DeliveryCityID]
        ORDER BY CountryTurnover DESC;
        RETURN;
    END

    RAISERROR('ReportCustomerTurnover : Invalide Choice (%d). Use 1, 2 ou 3.', 
               16, 1, @Choice);
END




SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE [dbo].[ReportCustomerTurnover]
	
	@Choice  int=1, 
	@Year int = 2013
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @TurnOver VARCHAR;
	SET @TurnOver = 'ToTalTurnOver' + CAST(@YEAR AS VARCHAR) ;
	
	IF @Choice = 1 AND  NOT(@Year IS NULL)
	
	BEGIN
		SELECT DISTINCT C.CustomerName, 

			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 1 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) As Jan ,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 2 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Feb,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 3 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Mar,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 4 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Apr,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 5 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS May,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 6 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Jun,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 7 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Jul,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 8 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Aug,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 9 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Sep,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 10 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Oct,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 11 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) As Nov,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 12 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS [Dec]

		FROM
		(	SELECT I.InvoiceID, I.CustomerID, I.InvoiceDate, IL.UnitPrice, IL.Quantity, IL.InvoiceLineID
			FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
			WHERE I.InvoiceID = IL.InvoiceID
		) AS T, Sales.Customers AS C 
		WHERE T.CustomerID = C.CustomerID
		AND YEAR(T.InvoiceDate) = @Year
		GROUP BY CustomerName  
		ORDER BY CustomerName ;
	END;
	IF @Choice = 2 AND  NOT(@Year IS NULL)
	BEGIN
		SELECT C.CustomerName, 

			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 1 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) As Q1 ,
			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 2 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Q2 ,
			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 3 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Q3,
			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 4 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Q4

		FROM
		(	SELECT I.InvoiceID, I.CustomerID, I.InvoiceDate, IL.UnitPrice, IL.Quantity, IL.InvoiceLineID
			FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
			WHERE I.InvoiceID = IL.InvoiceID
		) AS T, Sales.Customers AS C 
		WHERE T.CustomerID = C.CustomerID
		AND YEAR(T.InvoiceDate) = @Year
		GROUP BY CustomerName 	
		ORDER BY CustomerName ;
	END;
	IF @Choice = 3
	BEGIN
		SELECT C.CustomerName, 

			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2013 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2013' ,
			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2014 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2014' ,
			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2015 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2015',
			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2016 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2016'

		FROM
		(	SELECT I.InvoiceID, I.CustomerID, I.InvoiceDate, IL.UnitPrice, IL.Quantity, IL.InvoiceLineID
			FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
			WHERE I.InvoiceID = IL.InvoiceID
		) AS T, Sales.Customers AS C 
		WHERE T.CustomerID = C.CustomerID
		GROUP BY CustomerName 	
		ORDER BY CustomerName ;
	END;

END


EXEC dbo.ReportCustomerTurnover

EXEC dbo.ReportCustomerTurnover @Choice = 1, @Year = 2013

EXEC dbo.ReportCustomerTurnover @Choice = 1, @Year = 2014

EXEC dbo.ReportCustomerTurnover @Choice = 2, @Year = 2015

EXEC dbo.ReportCustomerTurnover @Choice = 2, @Year = 2016

EXEC dbo.ReportCustomerTurnover @Choice = 3




SELECT  D.CustomerCategoryName, D.MaxLoss, D.CustomerName, D.CustomerID
FROM
(SELECT DISTINCT S.CustomerCategoryName, S.MaxLoss, S.CustomerName, S.CustomerID, ROW_NUMBER() OVER (Partition by S.CustomerCategoryName  
		            Order by S.MaxLoss DESC) AS RowNo 
	FROM
	(SELECT CustomerCategoryName, SUM(F.UnitPrice * F.Quantity)  OVER ( Partition by CustomerCategoryName, F.CustomerName) AS MaxLoss, 
				F.CustomerName , F.CustomerID
		FROM
		(SELECT  C.CustomerName, C.CustomerId, C.CustomerCategoryId, L.UnitPrice, L.Quantity
			FROM
			(SELECT  T.CustomerID, T.OrderID, OL.UnitPrice, OL.Quantity
				FROM 
				(SELECT O.CustomerID, O.OrderID
					FROM Sales.Orders as O
					WHERE NOT EXISTS
					(SELECT *
						FROM Sales.Invoices as I
						WHERE I.OrderID = O.OrderID
					)
				) AS T, Sales.OrderLines AS OL
				WHERE T.OrderID = OL.OrderID
			) AS L, Sales.Customers AS C
			WHERE L.CustomerID = C.CustomerID
		) AS F, Sales.CustomerCategories AS G
		WHERE F.CustomerCategoryID = G.CustomerCategoryID
	) AS S 
) AS D
WHERE D.RowNo <=1
ORDER BY D.MaxLoss DESC




USE [SQLPlayground]

SELECT
    C.CustomerName
FROM dbo.Customer    AS C
  JOIN dbo.Purchase   AS PH
    ON C.CustomerID = PH.CustomerID
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Product AS P
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Purchase AS PU
        WHERE PU.CustomerID = C.CustomerID
          AND PU.ProductID  = P.ProductID))
GROUP BY
    C.CustomerName
HAVING
    SUM(PH.Qty) > 50