USE AdventureWorksDW2014

SELECT gETDATE();

--SELECTING ALL THE COLUMNS
SELECT * 
FROM FactInternetSales

--SELECT TOP 50 ROWS FROM THE SALE TABLE
SELECT TOP 50 *
FROM FactInternetSales

--What unique titles do we have?

SELECT * 
FROM DimCustomer

SELECT DISTINCT DC.Title
FROM DimCustomer DC

--How many unique birth dates are there?

SELECT *
FROM DimEmployee

SELECT DISTINCT EE.StartDate
FROM DimEmployee EE

--Can I get a list of distinct life expectancy ages ALSO Make sure there are no nulls

SELECT *
FROM DimEmployee


SELECT DISTINCT DATEDIFF(MONTH,EE.BirthDate,GETDATE())/12 AS AGES
FROM DimEmployee EE

--How many female customers do we MARRY?

SELECT *
FROM DimCustomer

SELECT DC.FirstName,DC.LastName,DC.Gender
FROM DimCustomer DC
WHERE DC.Gender = 'F'


 --get sales of specific product
SELECT *
FROM DimProduct

SELECT DP.EnglishProductName
FROM FactInternetSales FI
JOIN DimProduct DP
ON DP.ProductKey = FI.ProductKey
WHERE DP.EnglishProductName = 'ROAD-650 BLACK, 62'

--Calculate the total amount of employees per department and the total using grouping sets

SELECT *
FROM DimEmployee EM

SELECT EM.DepartmentName, COUNT(EM.EmployeeKey)EMPLOYEE_BY_EACH_DEPARTMENT
FROM DimEmployee EM
GROUP BY GROUPING SETS(EM.DepartmentName)

--What year was the youngest person born in the company?

SELECT * 
FROM DimCustomer

SELECT DM.Gender,DM.BirthDate,YEAR(DM.BIRTHDATE)YOUNGEST_IN_COMPANY
FROM DimEmployee DM
WHERE DM.BirthDate = (SELECT MAX(BirthDate) FROM DimEmployee)


--Who over the age of 44 has an income of 100 000 or more? (excluding 44)

SELECT *
FROM DimCustomer

SELECT DC.FirstName,DC.FirstName,DC.Gender,DATEDIFF(MONTH,DC.BirthDate,GETDATE())/12 AGE,DC.YearlyIncome
FROM DimCustomer DC
WHERE DATEDIFF(MONTH,DC.BIRTHDATE,GETDATE())/12 > 44 AND DC.YearlyIncome = '100000'

--Who between the ages of 30 and 50 has an income less than 50 000?
-- (include 30 and 50 in the results)

SELECT *
FROM DimCustomer

SELECT DC.FirstName,DC.FirstName,DC.Gender,DATEDIFF(MONTH,DC.BirthDate,GETDATE())/12 AGE,DC.YearlyIncome
FROM DimCustomer DC
WHERE (DATEDIFF(MONTH,DC.BIRTHDATE,GETDATE())/12 BETWEEN 30 AND 50 ) AND DC.YearlyIncome = '50000'

-- What is the average income between the ages of 20 and 50? (Excluding 20 and 50)
SELECT *
FROM DimEmployee 

SELECT EM.FirstName,EM.LastName, EM.Gender, DATEDIFF(MONTH,EM.BirthDate,GETDATE())/12 AS AGE
INTO NEW_TBL       -- I CREATE A NEW TABLE FOR AGE SO AS TO HELP RUN THE AVG AGES
FROM DimEmployee EM

SELECT NT.LastName,NT.FirstName,NT.Gender,AGE,AVG(NT.AGE) OVER()AVG_AGES
FROM NEW_TBL NT
WHERE AGE >=20 AND AGE <=50


--GET me all the employees above 60, use the appropriate date function
SELECT *
FROM DimEmployee E

SELECT E.FirstName,E.LastName,E.Gender,E.MaritalStatus,DATEDIFF(MONTH,E.BirthDate,GETDATE())/12 AS AGE
FROM DimEmployee E
WHERE DATEDIFF(MONTH,E.BirthDate,GETDATE())/12 > '60'

-- How many employees where hired in February?

SELECT *
FROM DimEmployee

SELECT E.FirstName,E.LastName,E.StartDate,DATENAME(MONTH,E.STARTDATE)MONTH
FROM DimEmployee E
WHERE DATENAME(MONTH,E.StartDate) = 'FEBRUARY' 


--How many employees were born in november?

SELECT E.EmployeeKey,E.BirthDate, COUNT(E.BIRTHDATE) OVER()TOTAL_COUNTINF_IN_A_ROW, DATENAME(MONTH,E.BIRTHDATE)
FROM DimEmployee E
WHERE DATENAME(MONTH,E.BIRTHDATE) = 'NOVEMBER'

--Who is the oldest employee?
--who is youngest employee?

SELECT *
FROM DimEmployee E

SELECT EE.LastName,EE.FirstName,EE.StartDate,(SELECT MAX(EE.STARTDATE) FROM DimEmployee GROUP BY ())OLDEST_EMPLOYEE,
DATEDIFF(MONTH,EE.StartDate,GETDATE())/12 AS AGE_OF_OLDEST_EMPLOYEE
FROM  DimEmployee EE
GROUP BY EE.LastName,EE.FirstName,EE.StartDate
ORDER BY EE.StartDate ASC


SELECT EE.LastName,EE.FirstName,EE.StartDate,(SELECT MIN(EE.STARTDATE) FROM DimEmployee GROUP BY ())OLDEST_EMPLOYEE,
DATEDIFF(MONTH,EE.StartDate,GETDATE())/12 AS AGE_OF_YOUNGEST_EMPLOYEE
FROM  DimEmployee EE
GROUP BY EE.LastName,EE.FirstName,EE.StartDate
ORDER BY EE.StartDate DESC

--How many orders were made in DECEMBER 2010?

SELECT * 
FROM FactInternetSales FIS

SELECT FIS.ProductKey,FIS.OrderDate,DATENAME(MONTH,FIS.OrderDate)MONTH_NAME
FROM FactInternetSales FIS
WHERE DATENAME(MONTH,FIS.OrderDate) = 'DECEMBER' AND YEAR(FIS.OrderDate) = '2010'


--Show me all the employee, hired after 1991, that have had more than 2 titles

SELECT * 
FROM DimCustomer

select * 
FROM DimEmployee

SELECT DE.FirstName,DE.LastName,DE.HireDate, DE.TITLE,COUNT(DE.Title)MORE_THAN_TITLES
FROM DimEmployee  DE
WHERE YEAR(DE.HireDate) > '1991'
GROUP BY DE.FirstName,DE.LastName,DE.HireDate,DE.Title
HAVING COUNT(DE.TITLE) > 2

--Show me all the employees that have had more than 15 salary changes that work in the department development

SELECT * 
FROM DimCustomer
SELECT *
FROM DimEmployee

SELECT DE.EmployeeKey,DE.Gender,DE.DepartmentName,COUNT(DC.YearlyIncome)
FROM DimEmployee DE
JOIN DimCustomer DC
ON DC.GeographyKey = DE.ParentEmployeeKey
WHERE DE.DepartmentName = DE.DepartmentName
GROUP BY DE.EmployeeKey,DE.Gender,DE.DepartmentName
HAVING COUNT(DC.YEARLYINCOME) > 15 

--GET ALL ORDER FOR 2013

SELECT *
FROM FactInternetSales

SELECT FO.ProductKey,FO.OrderDate AS '2013'
FROM FactInternetSales FO
JOIN DimProduct DP
ON FO.ProductKey = DP.ProductKey
WHERE YEAR(OrderDate) = '2013';

--OR 
--WE ALSO FILTERS IT THIS WAY.......
SELECT FO.ProductKey,FO.OrderDate AS '2013'
FROM FactInternetSales FO
JOIN DimProduct DP
ON FO.ProductKey = DP.ProductKey
WHERE OrderDate >= '2013-01-01' AND FO.OrderDate <= '2013-12-31'

--ONLY SHOW HOW PRODUCTS IN 2013 THAT SOLD MORE THAN 1M USD..

SELECT DPC.FrenchProductCategoryName,
DPC.SpanishProductCategoryName,
SUM(FS.SalesAmount)TOTAL_SALES,
MAX(FS.SalesAmount)MAX_SALESAMOUNT,
MIN(FS.SalesAmount)SALES_MINIMUM
FROM FactInternetSales FS
JOIN DimProduct DP
ON DP.ProductKey = FS.ProductKey
JOIN DimProductCategory DPC
ON DPC.ProductCategoryKey =DP.ProductSubcategoryKey
JOIN DimProductSubcategory PDS
ON PDS.ProductSubcategoryAlternateKey = DPC.ProductCategoryAlternateKey
WHERE YEAR(FS.OrderDate) = '2013'
GROUP BY DPC.FrenchProductCategoryName,DPC.SpanishProductCategoryName
HAVING SUM(FS.SalesAmount) > 1000000


--SHOW EACH SALES AVERAGES FOR GROUP, AND REGION ALL IN COUNTRY.
SELECT *
FROM FactInternetSales
SELECT * 
FROM DimSalesTerritory

SELECT DISTINCT ST.SalesTerritoryRegion,ST.SalesTerritoryGroup,ST.SalesTerritoryCountry,
AVG(FS.SalesAmount) OVER(PARTITION BY ST.SALESTERRITORYREGION ORDER BY SALESTERRITORYREGION)SALES_AVERAGES,
AVG(FS.SalesAmount) OVER(PARTITION BY ST.SALESTERRITORYGROUP ORDER BY SALESTERRITORYGROUP)GROUP_SALES_AVERAGES,
AVG(FS.SalesAmount) OVER(PARTITION BY SALESTERRITORYCOUNTRY ORDER BY SALESTERRITORYCOUNTRY)COUNTRY_SALES_AVERAGE
FROM FactInternetSales FS
JOIN DimSalesTerritory ST
ON FS.SalesTerritoryKey = ST.SalesTerritoryKey























--





