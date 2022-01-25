CREATE DATABASE POLIKLINIK;
USE POLIKLINIK;

CREATE TABLE SPESIALISASI(
	Kode_Spesial CHAR(5) NOT NULL,
	Spesialis VARCHAR(25) NOT NULL
	PRIMARY KEY (Kode_Spesial),
	CONSTRAINT Check_Spesial CHECK(
		Kode_Spesial LIKE 'SP[0-9][0-9][0-9]' 
	)
);

CREATE TABLE DOKTER(
	Id_Dokter CHAR(5) NOT NULL,
	Nama_Depan VARCHAR(15) NOT NULL,
	Nama_Belakang VARCHAR(15),
	Spesialis CHAR(5),
	Alamat VARCHAR(50) NOT NULL,
	No_Telepon VARCHAR(15),
	Tarif NUMERIC(10,2) NOT NULL,
	PRIMARY KEY(Id_Dokter),
	FOREIGN KEY(Spesialis) REFERENCES SPESIALISASI(Kode_Spesial) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT Check_Id_Dokter CHECK(
		Id_Dokter LIKE 'DR[0-9][0-9][0-9]' 
	)
);

CREATE TABLE PASIEN(
	Id_Pasien CHAR(5) NOT NULL,
	Nama_Depan VARCHAR(15) NOT NULL,
	Nama_Belakang VARCHAR(15),
	Gender CHAR(1) NOT NULL,
	Alamat VARCHAR(50),
	No_Telepon VARCHAR(15),
	Umur INT,
	PRIMARY KEY(Id_Pasien),
	CONSTRAINT Check_Pasien CHECK(
		Id_Pasien LIKE 'P[0-9][0-9][0-9][0-9]' AND
		(Gender LIKE 'L' OR Gender LIKE 'P')
	)
);

CREATE TABLE RESEP(
	Id_Resep CHAR(10) NOT NULL,
	Pasien_Id CHAR(5) NOT NULL,
	Dokter_Id CHAR(5) NOT NULL,
	Tanggal DATE NOT NULL,
	Harga NUMERIC(10,2),
	PRIMARY KEY(Id_Resep),
	FOREIGN KEY(Pasien_Id) REFERENCES PASIEN(Id_Pasien) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Dokter_Id) REFERENCES DOKTER(Id_Dokter) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT Check_Id_Resep CHECK(
		Id_Resep LIKE 'R[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	)
);

CREATE TABLE KATEGORI_OBAT(
	Id_Kategori CHAR(5) NOT NULL,
	Kategori VARCHAR(20) NOT NULL,
	PRIMARY KEY(Id_Kategori),
	CONSTRAINT Check_Id_Kategori CHECK(
		Id_Kategori LIKE 'OK[0-9][0-9][0-9]' 
	)
);

CREATE TABLE OBAT(
	Id_Obat CHAR(5) NOT NULL,
	Nama_Obat VARCHAR(25) NOT NULL,
	Harga_Satuan NUMERIC(10,2) NOT NULL,
	Kategori CHAR(5),
	PRIMARY KEY(Id_Obat),
	FOREIGN KEY(Kategori) REFERENCES KATEGORI_OBAT(Id_Kategori) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT Check_Id_Obat CHECK(
		Id_Obat LIKE 'OB[0-9][0-9][0-9]' 
	)
);

CREATE TABLE DETAIL_OBAT(
	Id_Obat CHAR(5) NOT NULL,
	Id_Resep CHAR(10) NOT NULL,
	Jumlah INT NOT NULL,
	PRIMARY KEY(Id_Obat, Id_Resep),
	FOREIGN KEY(Id_Obat) REFERENCES OBAT(Id_Obat) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Id_Resep) REFERENCES RESEP(Id_Resep) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO SPESIALISASI
VALUES	('SP001','Jantung'),
		('SP006','Bedah'),
		('SP005','Saraf'),
		('SP007','Mata'),
		('SP008','Anak');

INSERT INTO DOKTER
VALUES	('DR001','Syaiful','Anwar','SP001','Jakarta Pusat','+6281111222','150000'),
		('DR003','Edi','Harto','SP006','Bogor','+6221211321','200000'),
		('DR004','Andrea','Dian','SP008','Depok','+6288899988','100000'),
		('DR011','Dewi','','SP006','Bekasi','+6212332111','120000'),
		('DR009','Muhammad','Ridwan','SP001','Depok','+625656565','120000'),
		('DR012','Agung','Pribadi','SP005','Jakarta Pusat','+624545111','180000'),
		('DR007','James','Bon','SP007','Bekasi','+620000007','230000'),
		('DR010','Ida','Nurhaida','SP008','Bogor','+621921211','70000');

INSERT INTO PASIEN
VALUES	('P0001','Ubet','','L','Bandung','+6282222123','21'),
		('P0003','Juju','Jubaidah','P','Cimahi','','70'),
		('P0002','Bon','Kurei','L','Bogor','','45'),
		('P0005','Arya','Stak','P','Jakarta','+628989898','6'),
		('P0008','Mario','Bolateli','L','Depok','+627117213','21'),
		('P0009','Jamal','Widodo','L','Bekasi','+622167809','55'),
		('P0010','Kiara','','P','Bogor','','4'),
		('P0011','Bondan','Prakosa','L','Jakarta','+6200101011','21'),
		('P0013','Gatot','Kaca','L','Solo','','45'),
		('P0014','Pipit','','P','','+6233333333','23');

		
INSERT INTO RESEP
VALUES	('R250115001','P0001','DR011','2015/1/25',NULL),
		('R250115002','P0009','DR001','2015/1/25',NULL),
		('R260115001','P0008','DR007','2015/1/26',NULL),
		('R270115001','P0014','DR003','2015/1/27',NULL),
		('R300115001','P0010','DR010','2015/1/30',NULL),
		('R300115002','P0013','DR003','2015/1/30',NULL),
		('R010215001','P0009','DR001','2015/2/1',NULL),
		('R010215002','P0003','DR009','2015/2/1',NULL),
		('R010215003','P0010','DR010','2015/2/1',NULL),
		('R020215001','P0005','DR004','2015/2/2',NULL),
		('R020215002','P0009','DR001','2015/2/2',NULL),
		('R020215003','P0014','DR012','2015/2/2',NULL),
		('R030215001','P0005','DR004','2015/2/3',NULL),
		('R030215002','P0003','DR009','2015/2/3',NULL);

INSERT INTO KATEGORI_OBAT
VALUES	('OK001','Jantung'),
		('OK002','Saraf'),
		('OK003','Infus'),
		('OK004','Nutrisi'),
		('OK005','Mata');

INSERT INTO OBAT
VALUES	('OB001','Akrinor Tablet','65000','OK001'),
		('OB002','Cardiject Vial','7800','OK001'),
		('OB003','Fargoxin Injeksi','21000','OK001'),
		('OB004','Kendaron Ampul','20000','OK001'),
		('OB005','Tiaryt Tablet','16000','OK001'),
		('OB006','Exelon Capsule 3 Mg','70000','OK002'),
		('OB007','Fordesia Tablet','79000','OK002'),
		('OB008','Reminyl Tablet 4 Mg','33000','OK002'),
		('OB009','Albucid Tetes	Mata','15000','OK005'),
		('OB010','Cendo	Fenicol	Salep Mata','20000','OK005'),
		('OB011','Interflox	Tetes Mata','36000','OK005'),
		('OB012','Haemaccel	Infus','200000','OK003'),
		('OB013','Human	Albumin	Infus','900000','OK003'),
		('OB014','Curfos Syrup','74000','OK004'),
		('OB015','Vitacur Syrup','36000','OK004'),
		('OB016','Cerebrovit Active','133000','OK004');

INSERT INTO DETAIL_OBAT
VALUES	('OB013','R250115001','1'), 
		('OB002','R250115002','5'), 
		('OB003','R250115002','2'), 
		('OB012','R270115001','1'), 
		('OB015','R300115001','1'),
		('OB002','R010215001','5'),
		('OB001','R010215002','2'),
		('OB002','R010215002','4'),
		('OB014','R010215003','1'),
		('OB016','R020215001','2'),
		('OB002','R020215002','3'),
		('OB003','R020215002','1'),
		('OB007','R020215003','4'),
		('OB008','R020215003','6'),
		('OB016','R030215001','1'),
		('OB003','R030215002','2'),
		('OB004','R030215002','4');

/*1. Buatlah	query	untuk	mengembalikan	data	obat	yang	harga	satuannya	tidak	lebih	
dari	Rp 50.000,00.	Tampilkan	nama	obat,	harga,	dan	nama	kategorinya. */

SELECT	Nama_Obat,
		Harga_Satuan,
		KATEGORI_OBAT.Kategori
FROM	OBAT,KATEGORI_OBAT
WHERE	OBAT.Kategori = KATEGORI_OBAT.Id_Kategori AND
		Harga_Satuan < '50000';

/*2. Buatlah	 query	 untuk	 mengembalikan	 data	 pasien	 yang	 nama	 depannya	
mengandung	huruf	‘o’.	Tampilkan	semua	kolomnya	kecuali	nomor	telepon. */

SELECT	Id_Pasien,
		CONCAT(Nama_Depan,' ',Nama_Belakang) AS 'Nama_Pasien',
		Gender,
		Alamat,
		Umur
FROM	PASIEN
WHERE	Nama_Depan LIKE '%o%';

/*3. Buatlah	 query	 untuk	 mengembalikan data	 pasien	 yang	 berobat	 pada	 dokter	
spesialis	jantung.	Tampilkan	data	nama	(nama	lengkap),	umur,	dan	nama	dokter	
yang	menangani. */

SELECT	DISTINCT CONCAT(Pasien.Nama_Depan,' ',Pasien.Nama_Belakang) AS 'Nama_Pasien',
		Umur,
		CONCAT(Dokter.Nama_Depan,' ',Dokter.Nama_Belakang) AS 'Dokter'
FROM	PASIEN, RESEP, DOKTER, SPESIALISASI
WHERE	PASIEN.Id_Pasien = RESEP.Pasien_Id AND
		DOKTER.Id_Dokter = RESEP.Dokter_Id AND
		DOKTER.Spesialis = SPESIALISASI.Kode_Spesial AND
		SPESIALISASI.Spesialis LIKE 'Jantung';

/*4. Buatlah	query	untuk	menampilkan	resep	untuk	obat	‘Cardiject	Vial’.	Tampilkan	
nomor	resep,	dan	tanggalnya. */

SELECT	RESEP.Id_Resep,
		Tanggal
FROM	RESEP, DETAIL_OBAT, OBAT
WHERE	RESEP.Id_Resep = DETAIL_OBAT.Id_Resep AND
		DETAIL_OBAT.Id_Obat = OBAT.Id_Obat AND
		Nama_Obat LIKE 'Cardiject Vial'
ORDER BY Tanggal ASC;

/*5. Buatlah	 query	 untuk mengembalikan	 daftar	 nama	 obat	 yang	 dalam	 satu	 resep	
diminta	dalam	jumlah	lebih	dari	2.	Tampilkan	id	obat	dan	nama	obatnya	 tanpa	
duplikasi. */

SELECT DISTINCT	OBAT.Id_Obat AS Id_Obat,
		Nama_Obat
FROM	OBAT, DETAIL_OBAT, RESEP
WHERE	OBAT.Id_Obat = DETAIL_OBAT.Id_Obat AND
		DETAIL_OBAT.Id_Resep = RESEP.Id_Resep AND
		Jumlah > 2;

