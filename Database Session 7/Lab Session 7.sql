/*1. Display TreatmentId, and TreatmentName for every treatment which id is ‘TM001’ or
‘TM002’. (in) */

SELECT TreatmentId,TreatmentName
FROM MsTreatment
WHERE TreatmentID IN('TM001','TM002');

/*2. Display TreatmentName, and Price for every treatment which type is not ‘Hair Treatment’ and
‘Message / Spa’. (in, not in) */

UPDATE	MsTreatmentType  
SET		TreatmentTypeName = 'Massage / Spa'
WHERE	TreatmentTypeId = 'TT002';

/* Asistensi */
SELECT	TreatmentTypeName,TreatmentName,Price
FROM	MsTreatment INNER JOIN MsTreatmentType ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
WHERE	TreatmentTypeName NOT IN('Hair Treatment','Massage / Spa');

/* Soal */
SELECT	TreatmentName,Price
FROM	MsTreatment INNER JOIN MsTreatmentType ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
WHERE	TreatmentTypeName NOT IN('Hair Treatment','Massage / Spa');

/*3. Display CustomerName, CustomerPhone, and CustomerAddress for every customer whose
name is more than 8 charactes and did transaction on Friday.
(len, in, datename, weekday) */

SELECT CustomerName,CustomerPhone,CustomerAddress,LEN(CustomerName)
FROM MsCustomer INNER JOIN HeaderSalonServices ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE LEN(CustomerName) > 8 AND DATENAME(WEEKDAY,TransactionDate) = 'Friday'

/*4. Display TreatmentTypeName, TreatmentName, and Price for every treatment that taken by
customer whose name contains ‘Putra’ and happened on day 22th. (in, like, day) */

INSERT INTO DetailSalonServices
VALUES ('TR009','TM001');

SELECT TreatmentTypeName,TreatmentName,Price
FROM MsTreatmentType 
	INNER JOIN MsTreatment ON MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId
	INNER JOIN DetailSalonServices ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
	INNER JOIN HeaderSalonServices ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
	INNER JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE CustomerName LIKE '%Putra%' AND DAY(TransactionDate) = '22';

/*5. Display StaffName, CustomerName, and TransactionDate (obtained from TransactionDate in
‘Mon dd,yyyy’ format) for every treatment which the last character of treatmentid is an even
number. (convert, exists, right)*/

/*cara biasa */
SELECT	MsTreatment.TreatmentId,StaffName,CustomerName,
		CONVERT(VARCHAR,TransactionDate,107) AS TransactionDate
FROM	MsStaff 
		INNER JOIN HeaderSalonServices ON MsStaff.StaffId = HeaderSalonServices.StaffId
		INNER JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
		INNER JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
		INNER JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
WHERE	CAST(RIGHT(MsTreatment.TreatmentId,1) AS INT) % 2 = '0';

/* Pake Subquery */
SELECT	MsTreatment.TreatmentId,CustomerName,
		CONVERT(VARCHAR,TransactionDate,107) AS TransactionDate
FROM	HeaderSalonServices 
		INNER JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
		INNER JOIN MsStaff ON HeaderSalonServices.StaffId = MsStaff.StaffId
		INNER JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
		INNER JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId 
WHERE	EXISTS(SELECT MsTreatment.TreatmentId 
				FROM MsTreatment
				WHERE MsTreatment.TreatmentId = DetailSalonServices.TreatmentId AND 
				CAST(RIGHT(MsTreatment.TreatmentId,1) AS INT) % 2 = '0'); 

/* 6. Display CustomerName, CustomerPhone, and CustomerAddress for every customer that was
served by staff whose name’s length is an odd number.
(exists, len) */

SELECT CustomerName,CustomerPhone,CustomerAddress
FROM MsCustomer
WHERE EXISTS(SELECT StaffName 
				FROM MsStaff
				WHERE LEN(StaffName) % 2 != '0');

/* 7. Display ID (obtained form last 3 characters of StaffID), and Name (obtained by taking
character after the first space until character before second space in StaffName) for every staff
whose name contains at least 3 words and hasn’t served male customer .
(right, substring, charindex, len, exists, in,not like, like) */

SELECT	RIGHT(StaffId,3) AS ID,
		SUBSTRING(StaffName,CHARINDEX(' ',StaffName)+1,CHARINDEX(' ',StaffName,CHARINDEX(' ',StaffName))+1 ) AS [Name]
FROM	MsStaff
WHERE	LEN(StaffName) - LEN(REPLACE(StaffName,' ','')) + 1 > 2 AND
		EXISTS(SELECT CustomerGender
				FROM MsCustomer
				WHERE CustomerGender NOT LIKE 'Male');

/* 8. Display TreatmentTypeName, TreatmentName, and Price for every treatment which price is
higher than average of all treatment’s price.
(alias subquery, avg) */
/*8 tambahin colomn Average Price */

SELECT	TreatmentTypeName, TreatmentName, Price, alias.Average
FROM	MsTreatmentType INNER JOIN MsTreatment ON MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId
		,(SELECT AVG(Price) AS Average FROM MsTreatment) AS alias
WHERE	Price > alias.Average;

/* 9. Display StaffName, StaffPosition, and StaffSalary for every staff with highest salary or lowest
salary. (alias subquery, max, min) */

SELECT	StaffName, StaffPosition, StaffSalary
FROM	MsStaff, (SELECT MAX(StaffSalary) AS Maximum FROM MsStaff) AS highest,
		(SELECT MIN(StaffSalary) AS Minimum FROM MsStaff) AS lowest
WHERE	StaffSalary = highest.Maximum OR StaffSalary = lowest.Minimum;
		
/* 10. Display CustomerName,CustomerPhone,CustomerAddress, and Count Treatment (obtained
from the total number of treatment) for every transaction which has the highest total number of
treatment. (alias subquery, group by, max, count) */

SELECT	CustomerName, CustomerPhone, CustomerAddress,
		COUNT(MsTreatment.TreatmentId) AS [Count Treatment]
FROM	MsCustomer
		INNER JOIN HeaderSalonServices ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
		INNER JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
		INNER JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId,
		(SELECT MAX(TT.TotalTreatment) AS Maximum FROM
			(SELECT COUNT(MsTreatment.TreatmentId) AS TotalTreatment FROM 
				MsCustomer, DetailSalonServices, HeaderSalonServices, MsTreatment
				WHERE HeaderSalonServices.CustomerId = MsCustomer.CustomerId AND
					  DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId AND
					  DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
				GROUP BY MsCustomer.CustomerName, MsCustomer.CustomerPhone, MsCustomer.CustomerAddress) AS TT) AS MX
GROUP BY CustomerName, CustomerPhone, CustomerAddress, MX.Maximum
HAVING COUNT(MsTreatment.TreatmentId) = MX.Maximum;

