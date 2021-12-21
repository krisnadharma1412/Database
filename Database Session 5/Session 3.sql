CREATE DATABASE Database_Session3;
USE Database_Session3;

CREATE TABLE MsCustomer(
	CustomerId CHAR(5) NOT NULL,
	CustomerName VARCHAR(50),
	CustomerGender VARCHAR(10),
	CustomerPhone VARCHAR(13),
	CustomerAddress VARCHAR(100),
	PRIMARY KEY (CustomerId),
	CONSTRAINT CHK_CusId CHECK(
		CustomerId LIKE 'CU[0-9][0-9][0-9]' AND (CustomerGender LIKE 'Male' OR CustomerGender LIKE 'Female')
	)
);

INSERT INTO MsCustomer
VALUES	('CU001', 'Franky', 'Male', '628566543338', 'Daan mogot baru Street no 6'),
		('CU002', 'Emalia Dewi', 'Female', '6285264782135', 'Tanjung Duren Street no 185'),
		('CU003', 'Elysia Chen', 'Female', '6285754206611', 'Kebon Jeruk Street no 120'),
		('CU004', 'Brando Kartawijaya', 'Male', '6281170225561', 'Greenvil Street no 88'),
		('CU005', 'Andy Putra', 'Male', '6287751321421', 'Sunter Street no 42');

UPDATE MsCustomer
SET	CustomerPhone = REPLACE(MsCustomer.CustomerPhone,'62','0');

/* 5. Display Name (obtained by taking the first character of customer’s name until character before
space), Gender (obtained from first character of customer’s gender), and PaymentType for every
transaction that is paid by ‘Debit’. */
SELECT DISTINCT CASE CHARINDEX(' ',MsCustomer.CustomerName) WHEN 0 THEN MsCustomer.CustomerName
		ELSE LEFT(MsCustomer.CustomerName, CHARINDEX(' ', MsCustomer.CustomerName))
		END AS [Name],
		LEFT(CustomerGender,1) AS Gender,
		PaymentType
FROM MsCustomer INNER JOIN HeaderSalonServices ON(MsCustomer.CustomerId = HeaderSalonServices.CustomerId)
WHERE PaymentType = 'Debit';

/* 6. Display Initial (obtained from first character of customer’s name and followed by first character of
customer’s last name in uppercase format), and Day (obtained from the day when transaction
happened ) for every transaction which the day difference with 24th December 2012 is less than 3
days. */ 
SELECT  CASE CHARINDEX(' ',MsCustomer.CustomerName) WHEN 0 THEN LEFT(CustomerName,1)
		ELSE UPPER(CONCAT(LEFT(CustomerName,1),SUBSTRING(CustomerName,CHARINDEX(' ',CustomerName)+1,1)))
		END AS Initial,
		DATENAME(WEEKDAY,TransactionDate) AS [Day]
FROM MsCustomer INNER JOIN HeaderSalonServices ON(MsCustomer.CustomerId = HeaderSalonServices.CustomerId)
WHERE DATEDIFF(DAY,TransactionDate,'2012/12/24') < 3;

/* 7. Display TransactionDate, and CustomerName (obtained by taking the character after space until
the last character in CustomerName) for every customer whose name contains space and did the
transaction on Saturday. */
SELECT	TransactionDate,
		RIGHT(CustomerName,CHARINDEX(' ',REVERSE(CustomerName))) AS CustomerName
FROM MsCustomer INNER JOIN HeaderSalonServices ON(MsCustomer.CustomerId = HeaderSalonServices.CustomerId)
WHERE CHARINDEX(' ',MsCustomer.CustomerName) != 0 AND DATENAME(WEEKDAY,TransactionDate) = 'Saturday';


CREATE TABLE MsStaff(
	StaffId CHAR(5) NOT NULL,
	StaffName VARCHAR(50),
	StaffGender VARCHAR(10),
	StaffPhone VARCHAR(13),
	StaffAddress VARCHAR(100),
	StaffSalary NUMERIC(11,2),
	StaffPosition VARCHAR(20),
	PRIMARY KEY(StaffId),
	CONSTRAINT CHK_StfId CHECK(
		StaffId LIKE 'SF[0-9][0-9][0-9]'AND
		(StaffGender LIKE 'Male' OR StaffGender LIKE 'Female')
	)
);

INSERT INTO MsStaff
VALUES	('SF001', 'Dian Felita Tanoto', 'Female', '085265442222', 'Palmerah Street no 56', '15000000', 'Top Stylist'), 
		('SF002', 'Mellisa Pratiwi', 'Female', '085755552011', 'Kebon Jeruk Street no 151', '10000000', 'Top Stylist'), 
		('SF003', 'Livia Ashianti', 'Female', '085218542222', 'Kebon Jeruk Street no 19', '7000000', 'Stylist'), 
		('SF004', 'Indra Saswita', 'Male', '085564223311', 'Sunter Street no 91', '7000000', 'Stylist'), 
		('SF005', 'Ryan Nixion Salim', 'Male', '085710255522', 'Kebon Jeruk Street no 123', '3000000', 'Stylist'), 
		('SF006', 'Jeklin Harefa', 'Female', '085265433322', 'Kebon Jeruk Street no 140', '3000000', 'Stylist'), 
		('SF007', 'Lavinia Ayu', 'Female', '085755500011', 'Kebon Jeruk Street no 153', '3000000', 'Stylist'),
		('SF008', 'Stephen Adrianto', 'Male', '085564223311', 'Mandala Street no 14', '3000000', 'Stylist'),
		('SF009', 'Rico Wijaya', 'Male', '085710252525', 'Keluarga Street no 78', '3000000', 'Stylist');

/* 1. Display all female staff’s data from MsStaff. */
SELECT *
FROM MsStaff
WHERE StaffGender = 'Female';

/* 2. Display StaffName, and StaffSalary(obtained by adding ‘Rp.’ In front of StaffSalary) for every
staff whose name contains ‘m’ character and has salary more than or equal to Between 10000000.
(cast, like) */
SELECT	StaffName,
		CONCAT('Rp. ', CAST(StaffSalary AS VARCHAR)) AS [Staff Salary]
FROM	MsStaff
WHERE	StaffName LIKE '%M%' AND StaffSalary >= 10000000;

/* 4. Display StaffName, StaffPosition, and TransactionDate (obtained from TransactionDate in Mon
dd,yyyy format) for every staff who has salary between 7000000 and 10000000.
(convert, between) */
SELECT	StaffName,
		StaffPosition,
		CONVERT(VARCHAR, TransactionDate, 107) AS TransactionDate
FROM MsStaff INNER JOIN HeaderSalonServices ON(MsStaff.StaffId = HeaderSalonServices.StaffId)
WHERE StaffSalary BETWEEN 7000000 AND 10000000;

/* 8. Display StaffName, CustomerName, CustomerPhone (obtained from customer’s phone by
replacing ‘0’ with ‘+62’), and CustomerAddress for every customer whose name contains vowel
character and handled by staff whose name contains at least 3 words. */
SELECT	StaffName,
		CustomerName,
		CONCAT(REPLACE(LEFT(CustomerPhone,1),'0','+62'), SUBSTRING(CustomerPhone,2,LEN(CustomerPhone))) AS CustomerPhone,
		CustomerAddress
FROM	MsCustomer 
		INNER JOIN HeaderSalonServices ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
		INNER JOIN MsStaff ON HeaderSalonServices.StaffId = MsStaff.StaffId
WHERE	CustomerName LIKE '%[aiueo]%' AND
		LEN(StaffName) - LEN(REPLACE(StaffName,' ','')) + 1 > 2;

/* 9. Display StaffName, TreatmentName, and Term of Transaction (obtained from the day difference
between transactionDate and 24th December 2012) for every treatment which name is more than
20 characters or contains more than one word. (datediff, day, len, like) */
SELECT	StaffName,
		TreatmentName,
		ABS(DATEDIFF(DAY,TransactionDate,'2012/12/24')) AS [Term of Transaction]
FROM	MsStaff 
		INNER JOIN HeaderSalonServices ON MsStaff.StaffId = HeaderSalonServices.StaffId
		INNER JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
		INNER JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
WHERE	LEN(TreatmentName) > 20 OR
		LEN(TreatmentName) - LEN(REPLACE(TreatmentName,' ','')) + 1 > 1;
	

CREATE TABLE MsTreatmentType(
	TreatmentTypeId CHAR(5) NOT NULL,
	TreatmentTypeName VARCHAR(50),
	PRIMARY KEY(TreatmentTypeId),
	CONSTRAINT CHK_TTId CHECK(
		TreatmentTypeId LIKE 'TT[0-9][0-9][0-9]'
	)
);

INSERT INTO MsTreatmentType
VALUES	('TT001', 'Hair Treatment'),
		('TT002', 'Hair Spa Treatment'),
		('TT003', 'Beauty Care'),
		('TT004', 'Menicure Pedicure'),
		('TT005', 'Premium Treatment');

CREATE TABLE MsTreatment(
	TreatmentId CHAR(5) NOT NULL,
	TreatmentTypeId CHAR(5) NOT NULL,
	TreatmentName VARCHAR(50),
	Price NUMERIC(11,2),
	PRIMARY KEY(TreatmentId),
	FOREIGN KEY(TreatmentTypeId) REFERENCES MsTreatmentType (TreatmentTypeId) ON UPDATE CASCADE,
	CONSTRAINT CHK_TId CHECK(
		TreatmentId LIKE 'TM[0-9][0-9][0-9]'
	)
);

INSERT INTO MsTreatment
VALUES	('TM001', 'TT001', 'Cutting by Stylist','150000'),
		('TM002', 'TT001', 'Cutting by Top Stylist','450000'),
		('TM003', 'TT001', 'Cutting Pony','50000'),
		('TM004', 'TT001', 'Blow','90000'),
		('TM005', 'TT001', 'Coloring','480000'),
		('TM006', 'TT001', 'Highlight','320000'),
		('TM007', 'TT001', 'Japanese Perm','700000'),
		('TM008', 'TT001', 'Digital Perm','1100000'),
		('TM009', 'TT001', 'Special Perm','1100000'),
		('TM010', 'TT001', 'Rebonding Treatment','1100000'),
		('TM011', 'TT002', 'Creambath','150000'),
		('TM012', 'TT002', 'Hair Spa','250000'),
		('TM013', 'TT002', 'Hair Mask','250000'),
		('TM014', 'TT002', 'Hand Spa Reflexy','200000'),
		('TM015', 'TT002', 'Reflexy','250000'),
		('TM016', 'TT002', 'Back Therapy Massage','300000'),
		('TM017', 'TT003', 'Make Up','500000'),
		('TM018', 'TT003', 'Make Up Wedding','5000000'),
		('TM019', 'TT003', 'Facial','300000'),
		('TM020', 'TT004', 'Manicure','80000'),
		('TM021', 'TT004', 'Pedicure','100000'),
		('TM022', 'TT004', 'Nail Extension','250000'),
		('TM023', 'TT004', 'Nail Acrylic Infill','340000'),
		('TM024', 'TT005', 'Japanese Treatment','350000'),
		('TM025', 'TT005', 'Scalp Treatment','250000'),
		('TM026', 'TT005', 'Crystal Treatment','400000');	
		
/* 3. Display TreatmentName, and Price for every treatment which type is 'massage / spa' or 'beauty
care'. (in) */
SELECT	TreatmentName,
		Price
FROM MsTreatment INNER JOIN MsTreatmentType ON(MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId) 
WHERE	TreatmentTypeName IN('Message / Spa', 'Beauty Care');


CREATE TABLE HeaderSalonServices(
	TransactionId CHAR(5) NOT NULL,
	CustomerId CHAR(5) NOT NULL,
	StaffId CHAR(5) NOT NULL,
	TransactionDate DATE,
	PaymentType VARCHAR(20),
	PRIMARY KEY(TransactionId),
	FOREIGN KEY (CustomerId) REFERENCES MsCustomer (CustomerId) ON UPDATE CASCADE,
	FOREIGN KEY (StaffId) REFERENCES MsStaff (StaffId) ON UPDATE CASCADE,
	CONSTRAINT CHK_TrId CHECK(
		TransactionId LIKE 'TR[0-9][0-9][0-9]'
	)
);

INSERT INTO HeaderSalonServices
VALUES	('TR001', 'CU001', 'SF004', '2012/12/20', 'Credit'),
		('TR002', 'CU002', 'SF005', '2012/12/20', 'Credit'),
		('TR003', 'CU003', 'SF003', '2012/12/20', 'Cash'),
		('TR004', 'CU004', 'SF005', '2012/12/20', 'Debit'),
		('TR005', 'CU005', 'SF003', '2012/12/21', 'Debit'),
		('TR006', 'CU001', 'SF005', '2012/12/21', 'Credit'),
		('TR007', 'CU002', 'SF001', '2012/12/22', 'Cash'),
		('TR008', 'CU003', 'SF002', '2012/12/22', 'Credit'),
		('TR009', 'CU005', 'SF004', '2012/12/22', 'Debit'),
		('TR010', 'CU001', 'SF004', '2012/12/23', 'Credit'),
		('TR011', 'CU002', 'SF006', '2012/12/24', 'Credit'),
		('TR012', 'CU003', 'SF007', '2012/12/24', 'Cash'),
		('TR013', 'CU004', 'SF005', '2012/12/25', 'Debit'),
		('TR014', 'CU005', 'SF007', '2012/12/25', 'Debit'),
		('TR015', 'CU005', 'SF005', '2012/12/26', 'Credit'),
		('TR016', 'CU002', 'SF001', '2012/12/26', 'Cash'),
		('TR017', 'CU003', 'SF002', '2012/12/26', 'Credit'),
		('TR018', 'CU005', 'SF001', '2012/12/27', 'Debit');
/* 10. Display TransactionDate, CustomerName, TreatmentName, Discount (obtainedby changing Price
data type into int and multiply it by 20%), and PaymentType for every transaction which
happened on 22th day. (cast, day) */
SELECT	TransactionDate,
		CustomerName,
		TreatmentName,
		CAST(Price AS INT)*0.2 AS Discount,
		PaymentType
FROM	HeaderSalonServices 
		INNER JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
		INNER JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
		INNER JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
WHERE	DAY(TransactionDate) = 22;

SELECT DAY(TransactionDate)
FROM HeaderSalonServices;

CREATE TABLE DetailSalonServices(
	TransactionId CHAR(5) NOT NULL,
	TreatmentId CHAR(5) NOT NULL,
	FOREIGN KEY (TransactionId) REFERENCES HeaderSalonServices (TransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (TreatmentId) REFERENCES MsTreatment (TreatmentId) ON UPDATE CASCADE ON DELETE CASCADE,
);

ALTER TABLE DetailSalonServices
	ADD CONSTRAINT DSS PRIMARY KEY (TransactionId,TreatmentId);

INSERT INTO DetailSalonServices
VALUES	('TR007','TM002'),
		('TR008','TM003'),
		('TR009','TM005');
		('TR010','TM003'),
		('TR010','TM005'),
		('TR010','TM010'),
		('TR011','TM015'),
		('TR011','TM025'),
		('TR012','TM009'),
		('TR013','TM003'),
		('TR013','TM006'),
		('TR013','TM015'),
		('TR014','TM016'),
		('TR015','TM016'),
		('TR015','TM006'),
		('TR016','TM015'),
		('TR016','TM003'),
		('TR016','TM005'),
		('TR017','TM003'),
		('TR018','TM006'),
		('TR018','TM005'),
		('TR018','TM007');