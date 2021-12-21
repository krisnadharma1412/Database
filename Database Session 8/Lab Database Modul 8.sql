/*1. Create a view named ‘ViewBonus’ to display BinusId (obtained from CustomerID by replacing
the first 2 characters with ‘BN ’), and CustomerName for every customer whose name is more
than 10 characters. (create view, stuff, len) */

CREATE VIEW ViewBonus AS
	SELECT	STUFF(CustomerId,1,2,'BN') AS BinusId,
			CustomerName
	FROM	MsCustomer
	WHERE	LEN(CustomerName) >10;

SELECT *FROM ViewBonus;

/*2. Create a view named ‘ViewCustomerData’ to display Name (obtained from customer’s name from
the first character until a character before space), Address (obtained from CustomerAddress), and
Phone (obtained from CustomerPhone) for every customer whose name contains space.
(create view, substring, charindex) */

CREATE VIEW ViewCustomerData AS
	SELECT	SUBSTRING(MsCustomer.CustomerName,1,CHARINDEX(' ', MsCustomer.CustomerName)) AS [Name],
			CustomerAddress AS [Address],
			CustomerPhone AS Phone
	FROM	MsCustomer
	WHERE	CustomerName LIKE '% %';

SELECT *FROM ViewCustomerData;

/*3. Create a view named ‘ViewTreatment’ to display TreatmentName, TreatmentTypeName, Price
(obtained from Price by adding ‘Rp. ’ in front of Price) for every treatment which type is ‘Hair
Treatment’ and price is between 450000 and 800000. (create view, cast, between) */

CREATE VIEW ViewTreatment AS
	SELECT	TreatmentName, 
			TreatmentTypeName,
			CONCAT('Rp. ',Price) AS Price 
	FROM MsTreatment, MsTreatmentType 
	WHERE MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId AND 
	Price BETWEEN 450000 AND 800000; 

SELECT *FROM ViewTreatment;

/*4. Create a view named ‘ViewTransaction’ to display StaffName, CustomerName, TransactionDate
(obtained from TransactionDate in ‘dd mon yyyy’ format), and PaymentType for every transaction
which the transaction is between 21st and 25th day and was paid by ‘Credit’.
(create view, convert, day, between) */

CREATE VIEW ViewTransaction AS
	SELECT	StaffName,
			CustomerName,
			CONVERT(VARCHAR,TransactionDate,106) AS TransactionDate,
			PaymentType
	FROM	MsStaff,MsCustomer,HeaderSalonServices
	WHERE	MsStaff.StaffId = HeaderSalonServices.StaffId AND 
			MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
			DAY(TransactionDate) BETWEEN '21' AND '25' AND
			PaymentType = 'Credit';

SELECT *FROM ViewTransaction;

/*5. Create a view named ‘ViewBonusCustomer’ to display BonusId (obtained from CustomerId by
replacing ‘CU’ with ‘BN’), Name (Obtained from CustomerName by taking the next character
after space until the last character in lower case format), Day (obtained from the day when the
transaction happened), and TransactionDate (obtained from TransactionDate in ‘mm/dd/yy’
format) for every transaction which customer’s name contains space and staff’s last name contains
‘a’ character.
(create view, replace, lower, substring, charindex, len, datename, weekday, convert, like) */

CREATE VIEW ViewBonusCustomer AS
	SELECT	REPLACE(MsCustomer.CustomerId,'CU','BN') AS BonusId,
			LOWER(SUBSTRING(CustomerName,CHARINDEX(' ',CustomerName)+1,LEN(CustomerName))) AS [Name],
			DATENAME(WEEKDAY,TransactionDate) AS [Day],
			CONVERT(VARCHAR,TransactionDate,101) AS TransactionDate
	FROM	MsCustomer,MsStaff,HeaderSalonServices
	WHERE	MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
			MsStaff.StaffId = HeaderSalonServices.StaffId AND 
			CustomerName LIKE '% %' AND
			RIGHT(StaffName,1) = 'a';
SELECT *FROM ViewBonusCustomer; 

/* 6. Create a view named ‘ViewTransactionByLivia’ to display TransactionId, Date (obtained from
TransactionDate in ‘Mon dd, yyyy’ format), and TreatmentName for every transaction which
occurred on the 21st day and handled by staff whose name is ‘Livia Ashianti’.
(create view, convert, day, like) */

INSERT INTO DetailSalonServices
VALUES	('TR005','TM016');

CREATE VIEW ViewTransactionByLivia AS
	SELECT	HeaderSalonServices.TransactionId,
			CONVERT(VARCHAR,TransactionDate,107) AS TransactionDate,
			TreatmentName
	FROM HeaderSalonServices, MsTreatment, DetailSalonServices, MsStaff 
	WHERE	HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId AND
			DetailSalonServices.TreatmentId = MsTreatment.TreatmentId AND 
			HeaderSalonServices.StaffId = MsStaff.StaffId AND
	DAY(TransactionDate) = '21' AND 
	StaffName LIKE 'Livia Ashianti';
SELECT *FROM ViewTransactionByLivia;

/*7. Change the view named ‘ViewCustomerData’ to ID (obtained from the last 3 digit characters of
CustomerID), Name (obtained from CustomerName), Address (obtained from CustomerAddress),
and Phone (obtained from CustomerPhone) for every customer whose name contains space.
(alter view, right) */

ALTER VIEW ViewCustomerData AS
	SELECT	RIGHT(CustomerId,3) AS ID, 
			CustomerName AS [Name], 
			CustomerAddress AS [Address],
			CustomerPhone AS 'Phone' FROM MsCustomer
	WHERE CustomerName LIKE '% %';
SELECT *FROM ViewCustomerData;

/*8. Create a view named ‘ViewCustomer’ to display CustomerId, CustomerName, CustomerGender
from MsCustomer, then add the data to ViewCustomer with the following specifications:
CustomerID CustomerName CustomerGender
CU006	   Cristian	    Male
*/

CREATE VIEW ViewCustomer AS
	SELECT	CustomerId, 
			CustomerName, 
			CustomerGender 
	FROM MsCustomer;

INSERT INTO ViewCustomer (CustomerId, CustomerName, CustomerGender) 
VALUES ('CU006','Cristian','Male');

SELECT *FROM ViewCustomer;

/*9. Delete data in view ‘ViewCustomerData’ that has ID ‘005’. Then display all data from
ViewCustomerData. (delete) */

DELETE FROM ViewCustomerData 
WHERE ID = '005';

SELECT *FROM ViewCustomerData;

/*10. Delete the view named ‘ViewCustomerData’.
(drop view) */

DROP VIEW ViewCustomerData;

SELECT *FROM ViewCustomerData;




