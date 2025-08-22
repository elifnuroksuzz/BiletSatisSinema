IF DB_ID( 'sinema') IS NOT NULL
    BEGIN
        ALTER DATABASE [sinema] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
        USE master
        DROP DATABASE sinema
    END
GO

CREATE DATABASE sinema
    ON PRIMARY(
                NAME = 'sinemadb',
                FILENAME = '/Users/iremnurpirincci/Desktop : \database\sinema_db.mdf',
                SIZE = 5MB,
                MAXSIZE = 100MB,
                FILEGROWTH = 5MB
             )

LOG ON (
            NAME = 'sinemadb_10g',
            FILENAME = '/Users/iremnurpirincci/Desktop : \database\sinema_log.ldf',
            SIZE = 2MB,
            MAXSIZE = 50MB,
            FILEGROWTH = 1MB
        )
GO        
USE sinema

-- İl tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblIl')
BEGIN
    CREATE TABLE tblIl (
        ID INT PRIMARY KEY,
        AD VARCHAR(50)
    );
END;

-- İlçe tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblIlce')
BEGIN
    CREATE TABLE tblIlce (
        ID INT PRIMARY KEY,
        IL_ID  INT FOREIGN KEY(IL_ID) REFERENCES tblIl(ID),
        AD VARCHAR(50)
    );
END;

-- Sinema tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblSinema')
BEGIN
    CREATE TABLE tblSinema (
        SINEMA_ID INT PRIMARY KEY,
        AD VARCHAR(100),
        ACIKLAMA TEXT,
        ADRES VARCHAR(255),
        TELEFON_NUMARASI VARCHAR(10),
        WEB_SITESI_ADRESI VARCHAR(100),
        ACILDIGI_TARIH DATE,
        ORTALAMA_KULLANICI_PUANI DECIMAL(3,2),
        IL_ID INT FOREIGN KEY (IL_ID) REFERENCES tblIl(ID),
        ILCE_ID INT FOREIGN KEY (ILCE_ID) REFERENCES tblIlce(ID)
    );
END;

-- Salon tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblSalon')
BEGIN
    CREATE TABLE tblSalon (
        SALON_ID INT PRIMARY KEY,
        SINEMA_ID INT FOREIGN KEY (SINEMA_ID) REFERENCES tblSinema(SINEMA_ID),
        AD VARCHAR(100),
        TOPLAM_KOLTUK_SAYISI INT,
        BINADA_BULDUNDUGU_KAT INT,
        AKTIFLIK_DURUMU SMALLINT DEFAULT 1 NOT NULL -- 1 : Aktif , 0 : Pasif
    );
END;

-- Sıra tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblSıra')
BEGIN
    CREATE TABLE tblSıra (
        SIRA_ID INT PRIMARY KEY,
        AD VARCHAR(100)
    );
END;

-- Lokasyon tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblLokasyon')
BEGIN
    CREATE TABLE tblLokasyon (
        LOKASYON_ID INT PRIMARY KEY,
        AD VARCHAR(100)
    );
END;

-- Koltuk tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblKoltuk')
BEGIN
    CREATE TABLE tblKoltuk (
        KOLTUK_ID INT PRIMARY KEY,
        SALON_ID INT FOREIGN KEY (SALON_ID) REFERENCES tblSalon(SALON_ID),
        SIRA_ID INT  FOREIGN KEY (SIRA_ID) REFERENCES tblSıra(SIRA_ID),
        LOKASYON_ID INT FOREIGN KEY (LOKASYON_ID) REFERENCES tblLokasyon(LOKASYON_ID),
        KOLTUK_NUMARA VARCHAR(10),
        ENGELLI_MI SMALLINT DEFAULT 0 NOT NULL -- 1 : Engelli  0 : Engelsiz
    );
END;

-- Dil tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblDil')
BEGIN
    CREATE TABLE tblDil (
        DIL_ID INT PRIMARY KEY,
        AD VARCHAR(50)
    );
END;

-- Film Türü tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilmTürü')
BEGIN
    CREATE TABLE tblFilmTürü (
        FILMTURU_ID INT PRIMARY KEY,
        AD VARCHAR(50)
    );
END;

-- Film tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilm')
BEGIN
    CREATE TABLE tblFilm (
        FILM_ID INT PRIMARY KEY,
        AD VARCHAR(100),
        SURE INT,
        IMDB_PUANI DECIMAL(3, 1),
        BUTCE DECIMAL(18, 2),
        DIL_ID INT FOREIGN KEY (DIL_ID) REFERENCES tblDil(DIL_ID),
        VIZYON_TARIHI DATE,
        YAS_SINIRLAMASI VARCHAR(10),
        ORTALAMA_KULLANICI_PUANI DECIMAL(3,2),
        ACIKLAMA NVARCHAR(500),
        YAPIM_YILI DATE
    );
END;

-- Ülke tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblUlke')
BEGIN
    CREATE TABLE tblUlke (
        ID INT PRIMARY KEY,
        AD VARCHAR(20)
    );
END;

-- Firma tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFirma')
BEGIN
    CREATE TABLE tblFirma (
        FIRMA_ID INT PRIMARY KEY,
        AD VARCHAR(100),
        ADRES VARCHAR(255),
        TELEFON_NUMARASI VARCHAR(10) ,
        WEB_SITESI_ADRESI VARCHAR(100)
    );
END;

-- Yapım Ekibi Üyeleri tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblYapimEkibiUyeleri')
BEGIN
    CREATE TABLE tblYapimEkibiUyeleri (
        KISI_ID INT PRIMARY KEY,
        AD VARCHAR(100),
        SOYAD VARCHAR(100),
        YAS AS DATEDIFF(yy,DOGUM_TARIHI,GETDATE()),   
        OLUM_TARIHI DATE,
        DOGUM_TARIHI DATE
    );
END;

-- Üye tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblUye')
BEGIN
    CREATE TABLE tblUye (
        UYE_ID INT PRIMARY KEY,
        TC_KIMLIK_NO CHAR(11) UNIQUE NOT NULL, 
        AD VARCHAR(100),
        SOYAD VARCHAR(100),
        CINSIYET VARCHAR(10),
        TELEFON_NUMARASI VARCHAR(10),
        E_POSTA VARCHAR(100),
        DOGUM_TARIHI DATE,
        YAS AS DATEDIFF(yy,DOGUM_TARIHI,GETDATE()),   
        IL_ID  INT FOREIGN KEY(IL_ID) REFERENCES tblIl(ID),
        ILCE_ID  INT FOREIGN KEY(ILCE_ID) REFERENCES tblIlce(ID),
        SIFRE VARCHAR(20),
        ENGELLI_MI SMALLINT DEFAULT 0 NOT NULL, -- 0 : Engelsiz , 1 :Engelli 
        AKTIF_DURUMU SMALLINT DEFAULT 1 NOT NULL -- 1 : Aktif , 0 : Pasif
    );
END;

-- Personel tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblPersonel')
BEGIN
    CREATE TABLE tblPersonel (
        PERSONEL_ID INT PRIMARY KEY,
        TC_KIMLIK_NO CHAR(11),
        AD VARCHAR(100),
        SOYAD VARCHAR(100),
        CINSIYET VARCHAR(10),
        TELEFON_NUMARASI VARCHAR(10),
        E_POSTA VARCHAR(100),
        DOGUM_TARIHI DATE,
        MEDENI_HAL SMALLINT DEFAULT 0 NOT NULL, -- 1 : Evli , 0 : Bekar
        ISE_BASLAMA_TARIHI DATE,
        ISTEN_AYRILMA_TARIHI DATE,
        DOGUM_YERI VARCHAR(100)
    );
END;

-- Ücret tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblUcret')
BEGIN
    CREATE TABLE tblUcret (
        UCRET_ID INT PRIMARY KEY,
        TAM_UCRETI DECIMAL(10, 2),
        OGRENCI_UCRETI DECIMAL(10, 2)
    );
END;

-- Seans tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblSeans')
BEGIN
    CREATE TABLE tblSeans (
        ID INT PRIMARY KEY,
        SALON_ID INT FOREIGN KEY (SALON_ID) REFERENCES tblSalon(SALON_ID),
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        BASLANGIC_TARIHI DATE,
        BITIS_TARIHI DATE,
        ALT_YAZI_DURUMU SMALLINT DEFAULT 0 NOT NULL, -- 1: Altyazı var , 0 : Altyazı yok
        UCRET_ID INT FOREIGN KEY (UCRET_ID) REFERENCES tblUcret(UCRET_ID),
        GOSTERIM_DILI_ID INT FOREIGN KEY (GOSTERIM_DILI_ID) REFERENCES tblDil(DIL_ID)
    );
END;

-- Gün tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblGun')
BEGIN
    CREATE TABLE tblGun (
        ID INT PRIMARY KEY,
        SEANS_ID INT FOREIGN KEY (SEANS_ID) REFERENCES tblSeans(ID),
        AD VARCHAR(50),
        SAAT TIME
    );
END;

-- Bilet tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblBilet')
BEGIN
    CREATE TABLE tblBilet (
        ID INT PRIMARY KEY,
        UYE_ID INT FOREIGN KEY (UYE_ID) REFERENCES tblUye(UYE_ID),
        KOLTUK_ID INT FOREIGN KEY (KOLTUK_ID) REFERENCES tblKoltuk(KOLTUK_ID),
        SALON_ID INT FOREIGN KEY (SALON_ID) REFERENCES tblSalon(SALON_ID),
        SEANS_ID INT FOREIGN KEY (SEANS_ID) REFERENCES tblSeans(ID),
        PERSONEL_ID INT FOREIGN KEY (PERSONEL_ID) REFERENCES tblPersonel(PERSONEL_ID),
        UCRET_ID INT FOREIGN KEY (UCRET_ID) REFERENCES tblUcret(UCRET_ID),
        FIYAT DECIMAL(10,2),
        TARIH DATE,
        GUN_ID INT FOREIGN KEY (GUN_ID) REFERENCES tblGun(ID)
    );
END;



-- Akıllı İşaret tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblAkilliIsaret')
BEGIN
    CREATE TABLE tblAkilliIsaret (
        ID INT PRIMARY KEY,
        AD VARCHAR(20)
    );
END;

-- Özellik tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblOzellik')
BEGIN
    CREATE TABLE tblOzellik (
        ID INT PRIMARY KEY,
        AD VARCHAR(20)
    );
END;

-- Görev tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblGorev')
BEGIN
    CREATE TABLE tblGorev (
        ID INT PRIMARY KEY,
        AD VARCHAR(20),
        YAPIM_EKIBI_UYELERI_ID INT FOREIGN KEY (YAPIM_EKIBI_UYELERI_ID) REFERENCES tblYapimEkibiUyeleri(KISI_ID),
        PERSONEL_ID INT FOREIGN KEY (PERSONEL_ID) REFERENCES tblPersonel(PERSONEL_ID)
    );
END;

-- Firma-Film ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFirmaFilm')
BEGIN
    CREATE TABLE tblFirmaFilm ( 
        FIRMA_ID INT FOREIGN KEY (FIRMA_ID) REFERENCES tblFirma(FIRMA_ID),
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        PRIMARY KEY (FIRMA_ID, FILM_ID)
    );
END;

-- Film-Akıllı İşaret ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilmAkilliIsaret')
BEGIN
    CREATE TABLE tblFilmAkilliIsaret ( 
        AKILLI_ISARET_ID INT FOREIGN KEY (AKILLI_ISARET_ID) REFERENCES tblAkilliIsaret(ID),
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        PRIMARY KEY (AKILLI_ISARET_ID, FILM_ID)
    );
END;

-- Film-Özellik ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilmOzellik')
BEGIN
    CREATE TABLE tblFilmOzellik ( 
        OZELLIK_ID INT FOREIGN KEY (OZELLIK_ID) REFERENCES tblOzellik(ID),
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        PRIMARY KEY (OZELLIK_ID, FILM_ID)
    );
END;

-- Özellik-Sinema ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblOzellikSinema')
BEGIN
    CREATE TABLE tblOzellikSinema ( 
        OZELLIK_ID INT FOREIGN KEY (OZELLIK_ID) REFERENCES tblOzellik(ID),
        SINEMA_ID INT FOREIGN KEY (SINEMA_ID) REFERENCES tblSinema(SINEMA_ID),
        PRIMARY KEY (OZELLIK_ID, SINEMA_ID)
    );
END;

-- Film-Sinema ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilmSinema')
BEGIN
    CREATE TABLE tblFilmSinema ( 
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        SINEMA_ID INT FOREIGN KEY (SINEMA_ID) REFERENCES tblSinema(SINEMA_ID),
        PRIMARY KEY (FILM_ID, SINEMA_ID)
    );
END;

-- Film-Film Türü ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilmFilmTürü')
BEGIN
    CREATE TABLE tblFilmFilmTürü ( 
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        FILM_TURU_ID INT FOREIGN KEY (FILM_TURU_ID) REFERENCES tblFilmTürü(FILMTURU_ID),
        PRIMARY KEY (FILM_ID, FILM_TURU_ID)
    );
END;

-- Film-Ülke ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilmUlke')
BEGIN
    CREATE TABLE tblFilmUlke (
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        ULKE_ID INT FOREIGN KEY (ULKE_ID) REFERENCES tblUlke(ID),
        PRIMARY KEY (FILM_ID, ULKE_ID)
    );
END;

-- Film-Yapım Ekibi Üyeleri ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblFilmYapimEkibi')
BEGIN
    CREATE TABLE tblFilmYapimEkibi (
        FILM_ID INT FOREIGN KEY (FILM_ID) REFERENCES tblFilm(FILM_ID),
        KISI_ID INT FOREIGN KEY (KISI_ID) REFERENCES tblYapimEkibiUyeleri(KISI_ID),
        PRIMARY KEY (FILM_ID, KISI_ID)
    );
END;

-- Salon-Özellik ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblSalonOzellik')
BEGIN
    CREATE TABLE tblSalonOzellik (
        SALON_ID INT FOREIGN KEY (SALON_ID) REFERENCES tblSalon(SALON_ID),
        OZELLIK_ID INT FOREIGN KEY (OZELLIK_ID) REFERENCES tblOzellik(ID),
        PRIMARY KEY (SALON_ID, OZELLIK_ID)
    );
END;


-- Salon-Özellik ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblSeansSinema')
BEGIN
CREATE TABLE tblSeansSinema (
    SEANS_ID INT FOREIGN KEY (SEANS_ID) REFERENCES tblSeans(ID),
    SINEMA_ID INT FOREIGN KEY (SINEMA_ID) REFERENCES tblSinema(SINEMA_ID),
    PRIMARY KEY (SEANS_ID, SINEMA_ID),  
);
END;

-- Salon-Özellik ilişki tablosunu oluşturma (Eğer yoksa)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblSeansSinema')
BEGIN
CREATE TABLE tblUlkeYapimEkibiUyeleri (
    ULKE_ID INT FOREIGN KEY (ULKE_ID) REFERENCES tblUlke(ID),
    KISI_ID INT FOREIGN KEY (KISI_ID) REFERENCES tblYapimEkibiUyeleri(KISI_ID),
    PRIMARY KEY (ULKE_ID, KISI_ID),  
);
END;

-- İl tablosuna veri ekleme
IF NOT EXISTS (SELECT * FROM tblIl)
BEGIN
    INSERT INTO tblIl (ID, AD) VALUES 
    (1, 'İstanbul'), 
    (2, 'Ankara'), 
    (3, 'İzmir'), 
    (4, 'Yalova'),
	(5, 'Bursa');
END;

-- Insert data into 'tblIlce'
IF NOT EXISTS (SELECT * FROM tblIlce)
BEGIN
    INSERT INTO tblIlce (ID, AD, IL_ID) VALUES
    (1, 'Kadıköy', 1),
    (2, 'Pendik', 1),
    (3, 'Polatlı', 2),
    (4, 'Çiftlikköy', 4),
    (5, 'Merkez', 4),
    (6, 'Çınarcık', 4),
    (7, 'Buca', 3);
END;

IF NOT EXISTS (SELECT * FROM tblSinema)
BEGIN
INSERT INTO tblSinema (SINEMA_ID, AD, ACIKLAMA, ADRES, TELEFON_NUMARASI, WEB_SITESI_ADRESI, ACILDIGI_TARIH, ORTALAMA_KULLANICI_PUANI, IL_ID, ILCE_ID)
VALUES 
(1, 'Caddebostan CKM Sineması Sinema Salonu', 'Modern sinema kompleksi', 'Caddebostan Mah. Haldun Taner Sokak, No: 11 Caddebostan Kadıköy İstanbul', '1234567890', 'https://www.sinemalar.com/sinemasalonu/2254/caddebostan-ckm-sinemasi', '2022-01-01', 5.5, 1, 1),
(2, 'Ankara Polatlı Kartaltepe AVM D Vizyon Sinema Salonu', 'Geniş film seçeneği', 'İstiklal, Kartaltepe AVM, Mehmet Emin Yurdakul Cd. No:1, 06900 Polatlı/Ankara', '0987654321', 'https://www.sinemalar.com/sinemasalonu/2251/ankara-polatli-kartaltepe-avm-d-vizyon', '2022-02-15', 7.2, 2, 3),
(3, 'İzmir Univercity Park Sinema Salonu', 'Aile dostu sinema', 'Kuruçeşme Mah. Doğuş Cad. 9 Eylül Üniversitesi Tınaztepe Yerleşkesi No:207 Buca/İzmir', '1357924680', 'https://www.sinemalar.com/sinemasalonu/2234/izmir-univercity-park', '2022-03-20', 4.0, 3, 7),
(4, 'Yalova Özdilek Cinetime Sinema Salonu', 'Büyük ekranlar', 'Yalova - İzmit Karayolu Sahil Mah. No. 85 Özdilek Yalova AVM Çiftlikköy / Yalova', '2468013579', 'https://www.sinemalar.com/sinemasalonu/1624/yalova-ozdilek-cinetime', '2022-04-10', 4.1, 4, 4),
(5, 'Yalova Kipa Cinema Pink Sinema Salonu', 'Büyük ekranlar', 'Kazım Karabekir Mah. Şehit Ömer Faydalı Cad. Kipa AVM Kat : 2 Yalova', '2468013579', 'https://www.sinemalar.com/sinemasalonu/1676/yalova-kipa-cinema-pink', '2022-04-10', 4.1, 4, 5);
END;

-- Veri Ekleme
IF NOT EXISTS (SELECT * FROM tblDil)
BEGIN
INSERT INTO tblDil (DIL_ID, AD) VALUES
(1, 'Türkçe'),
(2, 'İngilizce'),
(3, 'Fransızca');
END;

IF NOT EXISTS (SELECT * FROM tblFilmTürü)
BEGIN
-- Insert data into tblFilmTürü
INSERT INTO tblFilmTürü (FILMTURU_ID, AD) VALUES
(1, 'Aksiyon'),
(2, 'Dram'),
(3, 'Komedi');
END;

IF NOT EXISTS (SELECT * FROM tblUlke)
BEGIN
INSERT INTO tblUlke (ID, AD) VALUES
(1, 'Türkiye'),
(2, 'Amerika' ),
(3, 'Fransa');
END;

IF NOT EXISTS (SELECT * FROM tblFirma)
BEGIN
-- Insert data into tblFirma
INSERT INTO tblFirma (FIRMA_ID, AD, ADRES, TELEFON_NUMARASI, WEB_SITESI_ADRESI) VALUES
(1, '25 Film', 'Levent, Fulyalı Sokağı No:11, 34330 Beşiktaş/İstanbul', '1934567890', 'https://25film.net/'),
(2, 'Avşar Film', 'Levent, No, Karanfil Sokağı No:33, 34330 Beşiktaş/İstanbul', '5234567890', 'https://www.avsarfilm.com.tr/'),
(3, 'Beşiktaş Kültür Merkezi', 'Sinanpaşa, Hasfırın Cd. No:85, 34353 Beşiktaş/İstanbul', '1254567890', 'https://bkmonline.net/'),
(4, 'Marvel Studios', '500 S. Buena Vista Street, Burbank, Kaliforniya, ABD', '2234567850', 'https://www.marvel.com/movies'),
(5, '20th Century Studios', 'Los Angeles, Kaliforniya, ABD', '1534557890', 'https://www.20thcenturystudios.com/');
END;

IF NOT EXISTS (SELECT * FROM tblAkilliIsaret)
BEGIN
-- Insert data into tblAkilliIsaret
INSERT INTO tblAkilliIsaret (ID, AD) VALUES
(1, 'Şiddet ve Korku'),
(2, 'Genel İzleyici'),
(3, 'Olumsuz Örnek');
END;

IF NOT EXISTS (SELECT * FROM tblOzellik)
BEGIN
-- Insert data into tblOzellik
INSERT INTO tblOzellik (ID, AD) VALUES
(1, '3D'),
(2, 'IMAX'),
(3, 'Dolby Atmos');
END;

IF NOT EXISTS (SELECT * FROM tblYapimEkibiUyeleri)
BEGIN
INSERT INTO tblYapimEkibiUyeleri (KISI_ID, AD, SOYAD, DOGUM_TARIHI, OLUM_TARIHI) VALUES
(1, 'Bruce', 'Willis', '1955-03-19', NULL),
(2, 'Harrison', 'Ford', '1942-03-13', NULL),
(3, 'Helen', 'Mirren', '1945-07-26', NULL),
(4, 'Olivia', 'Brown', '1942-08-13', NULL),
(5, 'Mia', 'Wilson', '1995-07-17', NULL),
(6, 'Ali', 'Arslan', '1980-11-23', NULL),
(7, 'Adile', 'Naşit', '1930-06-17', '1987-12-11'),
(8, 'İbrahim', 'Çelikkol', '1982-02-14', NULL),
(9, 'Kemal', 'Sunal', '1944-11-11', '2000-07-03'),
(10, 'Mine', 'Tugay', '1978-07-28', NULL),
(11, 'İsmail', 'Hacıoğlu', '1985-11-30', NULL),
(12, 'Scarlett', 'Johansson', '1984-11-22', NULL),
(13, 'Robert', 'Downey Jr.', '1965-04-04', NULL),
(14, 'Chris', 'Hemsworth', '1983-08-11', NULL),
(15, 'Elizabeth', 'Olsen', '1989-02-16', NULL),
(16, 'Diane', 'Fleri', '1983-07-13', NULL);
END;

-- Insert data into 'tblFilm'
IF NOT EXISTS (SELECT * FROM tblFilm)
BEGIN
    INSERT INTO tblFilm (FILM_ID, AD, SURE, IMDB_PUANI, BUTCE, DIL_ID, VIZYON_TARIHI, YAS_SINIRLAMASI, ORTALAMA_KULLANICI_PUANI, ACIKLAMA, YAPIM_YILI) VALUES
    (1, 'Tetikçi', 126, 8.3, 90000000, 2, '2007-05-11', '13', 8.0, 'Shooter 2007 yılı Amerikan yapımı macera filmi', '2006'),
    (2, 'Türkler Geliyor: Adaletin Kılıcı', 91, 8.7, 30000000, 1,'1976-01-19', '10', 4.7, 'Sahte diplomalarla Mahmut Hocayı kandıran hababam sınıfı yine sınıfta kalmıştır.', '1975'),
    (3, 'Fetih 1453', 165, 6.5, 18200000, 1, '2012-02-16', '16', 7.8, 'İstanbulun fethini konu alır.', '2009'),
    (4, 'Maymunlar Cehennemi: Başlangıç', 105, 8.0, 90000000,1, '2011-08-05', '13', 8.3, 'Maymunlar Cehennemi: Başlangıç, 2011 Amerikan bilimkurgu filmi.', '2011'),
    (5, 'Ayla', 125, 8.5, 21000000, 1, '2017-10-27', '7', 4.5, '2017 yılı çıkışlı Türkiye ve Güney Kore ortak yapımı dram ve savaş türündeki bir sinema filmidir.', '2017'),
    (6, 'Avengers: Endgame', 182, 8.4, 356000000, 2, '2019-04-26', '13', 4.4, '2018 yapımı Avengers: Sonsuzluk Savaşı filminin devamı niteliğinde olup yirmi ikinci Marvel Sinematik Evreni filmidir.', '2018'),
    (7, 'Minyonlar 2: Grunun Yükselişi', 87, 6.5, 80000000, 2, '2022-07-01', '6', 4.8, 'Çılgın Hırsız üçlemesinin spin-offudur.', '2018'),
    (8, 'Rüzgârı Dizginleyen Çocuk', 113, 7.9, 30000000, 2, '2019-01-29', '12', 8.0, '2019 Birleşik Krallık yapımı dramatik filmdir.', '2019'),
    (9, 'Ölümlü Dünya', 107, 7.6, 40000000, 1, '2018-01-26','13', 7.2, 'Ölümlü Dünya, başroldeki Danyal ile iş ortağı Harun, birçok farklı meslek dalında başarısız olmuş kişilerdir. Bir gün, bir kaza sonucu sahip oldukları dükkanın zengin sahibi olduğunu öğrenirler. Bu sırada, dükkanın sahibi olan kişi, öldükten sonra ikisinin üzerine dükkanı ve varlıklarını bırakmıştır.', '2017'),
    (10, 'Hababam Sınıfı Sınıfta Kaldı', 91, 8.7, 30000000, 1, '1976-01-01', '6', 8.0, 'Sahte diplomalarla Mahmut Hocayi kandiran hababam sinifi yine sinifta kalmistir. ', '1976'),
    (11, 'Kung Fu Panda 4', 94, 6.5, 85000000, 2, '2024-04-05', '6', 4.5, 'Yeni görevi, beklenmedik zorluklarla ve garantili kahkaha dolu anlarla dolu animasyonlu bir macera...', '2024'),
    (12, 'Kolpaçino 4 4lük', 95, 2.2, 20000000, 1, '2024-04-12', '13', 4.1, 'Kolpaçino serisinin dördüncü filmidir', '2024'),
    (13, 'Godzilla ve Kong: Yeni İmparatorluk', 115, 4.5, 31700000, 2, '2024-04-05', '13', 6.0, 'Godzilla ve Kong, devasa bir tehlikenin karşısında birleşiyor! ', '2024'),
    (14, 'Rekabet', 131, 3.7, 457794680, 1, '2024-04-26', '16', 4.0, 'Aşk, Tenis ve İkilem: Tashinin Hayatta ve Sahada Karşılaştığı Zorlu Mücadele ', '2024'),
    (15, 'Dublör', 126, 5.3, 130000000, 2, '2024-04-26', '10', 4.5, 'Aksiyonun Yıldızı Kayboldu, Gerilim Yükseliyor. Colt Seavers Tehlikenin İçinde! ', '2024');

END;

IF NOT EXISTS (SELECT * FROM tblPersonel)
BEGIN
  INSERT INTO tblPersonel (PERSONEL_ID, TC_KIMLIK_NO, AD, SOYAD, CINSIYET, TELEFON_NUMARASI, E_POSTA, DOGUM_TARIHI, MEDENI_HAL, ISE_BASLAMA_TARIHI, ISTEN_AYRILMA_TARIHI, DOGUM_YERI)
    VALUES 
    (1, '12345678901', 'Ahmet', 'Yılmaz', 'Erkek', '1234567890', 'ahmet@example.com', '1990-05-15', 1, '2015-03-10', NULL, 'Ankara'),
    (2, '23456789012', 'Ayşe', 'Kaya', 'Kadın', '1234567890', 'ayse@example.com', '1992-10-20', 0, '2018-01-20', NULL, 'İstanbul'),
    (3, '34567890123', 'Mehmet', 'Demir', 'Erkek', '1234567890', 'mehmet@example.com', '1985-12-30', 1, '2008-08-05', '2023-04-15', 'İzmir'),
    (4, '45678901234', 'Fatma', 'Şahin', 'Kadın', '1234567890', 'fatma@example.com', '1995-06-25', 0, '2017-11-10', NULL, 'Bursa');
END;

IF NOT EXISTS (SELECT * FROM tblGorev)
BEGIN
  -- Insert data into tblGorev
INSERT INTO tblGorev (ID, AD, YAPIM_EKIBI_UYELERI_ID, PERSONEL_ID) VALUES
(1, 'Yapımcı ', NULL, 1),
(2, 'Menajer', NULL, 2),
(3, 'Oyuncu', 1, NULL),
(4, 'Oyuncu', 13, NULL),
(5, 'Oyuncu', 14, NULL),
(6, 'Oyuncu', 7, NULL),
(7, 'Oyuncu', 9, NULL),
(8, 'Oyuncu', 10, NULL),
(9, 'Oyuncu', 8, NULL),
(10, 'Oyuncu', 2, NULL),
(11, 'Oyuncu', 3, NULL),
(12, 'Senarist', NULL, 3),
(13, 'Makyaj Sanatçısı', NULL, 4);
END;

-- Insert data into 'tblSalon'
IF NOT EXISTS (SELECT * FROM tblSalon)
BEGIN
    INSERT INTO tblSalon (SALON_ID, AD, SINEMA_ID,TOPLAM_KOLTUK_SAYISI,BINADA_BULDUNDUGU_KAT,AKTIFLIK_DURUMU) VALUES
    (1, 'Salon 1', 1, 100, 1, 1),
    (2, 'Salon 2', 1, 200, 2, 1),
    (3, 'Salon 1', 2, 300, 1, 0),
    (4, 'Salon 2', 2, 400, 2, 1),
    (5, 'Salon 1', 3, 500, 1, 1),
    (6, 'Salon 2', 3, 600, 2, 0),
    (7, 'Salon 1', 4, 700, 1, 1),
    (8, 'Salon 2', 4, 800, 2, 1),
    (9, 'Salon 1', 5, 900, 1, 1),
    (10, 'Salon 2',5, 1000, 2, 0),
    (11, 'Salon 1',1, 900, 2, 1),
    (12, 'Salon 2',3, 800, 1, 1),
    (13, 'Salon 1',2, 700, 1, 1),
    (14, 'Salon 2',1, 600, 2, 1);
END;

IF NOT EXISTS (SELECT * FROM tblSıra)
BEGIN
  -- Veri Ekleme
    INSERT INTO tblSıra (SIRA_ID, AD)
    VALUES 
    (1, 'A'),
    (2, 'B'),
    (3, 'C'),
    (4, 'D');
END;

IF NOT EXISTS (SELECT * FROM tblLokasyon)
BEGIN
  INSERT INTO tblLokasyon (LOKASYON_ID, AD)
    VALUES 
    (1, 'Salon Girişi'),
    (2, 'Lobi'),
    (3, 'Duvar Kenarı'),
    (4, 'Cam Kenarı');
END;

-- Insert data into 'tblKoltuk'
IF NOT EXISTS (SELECT * FROM tblKoltuk)
BEGIN
    INSERT INTO tblKoltuk (KOLTUK_ID, SALON_ID, SIRA_ID, LOKASYON_ID, KOLTUK_NUMARA, ENGELLI_MI) 
    VALUES
    (1, 1, 1, 1,'A1',0), (2, 1, 2,1,'B2',0), (3, 1, 1, 3,'C3',1), (4, 1, 1, 4,'D4',0), (5, 1, 1, 1,'E5',0), (6, 1, 1, 2,'F6',0), (7, 1, 1, 3,'G7',0), (8, 1, 1, 3,'H8',0), (9, 1, 1, 4,'K9',1), (10, 1, 1, 1,'L10',0),
    -- Salon 2
    (11, 2, 1, 2,'A2',1), (12, 2, 1, 2,'B2',0), (13, 2, 1, 3,'C3',0), (14, 2, 1, 4,'D4',0), (15, 2, 1, 3,'E5',1), (16, 2, 1, 4,'F6',0), (17, 2, 1, 1,'G7',0), (18, 2, 1, 2,'H8',0), (19, 2, 1, 3,'K9',0), (20, 2, 1, 4,'L10',0),
    -- Salon 3
    (21, 3, 1, 1,'A1',0), (22, 3, 1, 2,'B2',0), (23, 3, 1, 3,'C3',1), (24, 3, 1, 4,'D4',0), (25, 3, 1, 1,'E5',0), (26, 3, 1, 2,'F6',0), (27, 3, 1, 3,'G7',0), (28, 3, 1, 4,'H8',0), (29, 3, 1, 1,'K9',0), (30, 3, 1, 1,'L10',0),
    -- Salon 4
    (31, 4, 1, 1,'A1',0), (32, 4, 1, 2,'B2',0), (33, 4, 1, 3,'C3',1), (34, 4, 1, 4,'D4',0), (35, 4, 1, 4,'E5',0), (36, 4, 1, 3,'F6',0), (37, 4, 1, 2,'G7',0), (38, 4, 1, 1,'H8',0), (39, 4, 1, 2,'K9',0), (40, 4, 1, 3,'L10',0),
    -- Salon 5
    (41, 5, 1, 1,'A1',0), (42, 5, 1, 2,'B2',0), (43, 5, 1, 3,'C3',1), (44, 5, 1, 4,'D4',0), (45, 5, 1, 1,'E5',0), (46, 5, 1, 2,'F6',0), (47, 5, 1, 3,'G7',0), (48, 5, 1, 4,'H8',0), (49, 5, 1, 3,'K9',0), (50, 5, 1, 2,'L10',0);
END;

IF NOT EXISTS (SELECT * FROM tblUcret)
BEGIN
  INSERT INTO tblUcret (UCRET_ID, TAM_UCRETI, OGRENCI_UCRETI)
    VALUES 
    (1, 600.00, 500.00),
    (2, 740.00, 660.00),
    (3, 860.00, 710.00),
    (4, 750.00, 600.00),
    (5, 1200.00, 1000.00),
    (6, 1250.00, 1050.00),
    (7, 1170.00, 970.00),
    (8, 850.00, 700.00),
    (9, 830.00, 770.00),
    (10, 900.00, 800.00),
    (11, 1210.00, 1160.00);
END;


IF NOT EXISTS (SELECT * FROM tblSeans)
BEGIN
    INSERT INTO tblSeans (ID, SALON_ID,FILM_ID, BASLANGIC_TARIHI,BITIS_TARIHI,ALT_YAZI_DURUMU,UCRET_ID,GOSTERIM_DILI_ID) VALUES
    (1, 1, 5, '2023-02-27', '2023-12-27', 0, 6, 1),
	(2, 8, 7, '2023-03-01', '2023-08-01', 1, 11, 2),
    (3, 5, 9, '2023-01-26', '2023-12-26', 0, 6, 1),
	(4, 3, 1, '2023-01-11', '2023-06-11', 1, 1, 2),
	(5, 10, 6, '2023-04-26', '2023-05-26', 1, 2, 2),
    (6, 4, 6, '2024-01-01', '2024-07-01', 1, 3, 2),
    (7, 7, 6, '2024-01-01', '2024-07-01', 1, 4, 2),
    (8, 3, 6, '2024-01-26', '2024-07-26', 1, 5, 2),
    (9, 2, 6, '2024-01-26', '2024-07-26', 1, 6, 2),
    (10, 2, 6, '2024-01-26', '2024-07-26', 1, 7, 2),
    (11, 14, 6, '2024-02-21', '2024-08-21', 0, 8, 1),
    (12, 13, 6, '2024-03-02', '2024-09-02', 1, 9, 2),
    (13, 12, 6, '2024-04-03', '2024-12-03', 0, 10, 1),
    (14, 11, 6, '2024-05-10', '2025-01-10', 1, 11, 1),
    (15, 11, 10, '2024-03-10', '2025-09-10', 0, 6, 1),
    (16, 10, 10, '2024-03-11', '2025-09-11', 0, 6, 1),
    (17, 9, 10, '2024-03-12', '2025-09-12', 0, 11, 1),
    (18, 2, 10, '2024-03-13', '2025-09-13', 0, 11, 1),
    (19, 13, 10, '2024-03-14', '2025-09-14', 0, 5, 1),
    (20, 14, 10, '2024-03-15', '2025-09-15', 0, 5, 1),
    (21, 11, 10, '2024-04-15', '2025-10-15', 0, 6, 1),
    (22, 11, 11, '2024-05-16', '2025-11-16', 0, 7, 1),
    (23, 1, 12, '2024-01-19', '2025-07-19', 0, 8, 1),
    (24, 4, 13, '2024-02-21', '2025-08-21', 0, 9, 1),
    (25, 6, 14, '2024-06-21', '2025-12-21', 0, 11, 1);


END;

IF NOT EXISTS (SELECT * FROM tblGun)
BEGIN
    -- Veri Ekleme
    INSERT INTO tblGun (ID, SEANS_ID, AD, SAAT)
    VALUES 
    (1, 1, 'Pazartesi', '14:00'),
    (2, 1, 'Pazartesi', '18:00'),
    (3, 2, 'Salı', '15:00'),
    (4, 3, 'Salı', '18:00'),
    (5, 2, 'Çarşamba', '14:00'),
    (6, 4, 'Çarşamba', '18:00'),
    (7, 2, 'Perşembe', '15:00'),
    (8, 4, 'Perşembe', '18:00'),
    (9, 1, 'Cuma', '15:00'),
    (10, 2, 'Cuma', '18:00'),
    (11, 2, 'Cumartesi', '14:00'),
    (12, 3, 'Cumartesi', '18:00'),
    (13, 4, 'Pazar', '15:00'),
    (14, 4, 'Pazar', '18:00');
END;

IF NOT EXISTS (SELECT * FROM tblUye )
BEGIN
INSERT INTO tblUye (UYE_ID, TC_KIMLIK_NO, AD, SOYAD, DOGUM_TARIHI, CINSIYET, TELEFON_NUMARASI, E_POSTA, IL_ID, ILCE_ID, SIFRE, AKTIF_DURUMU, ENGELLI_MI)
VALUES
(1, '12345678901', 'Ahmet', 'Yılmaz', '1990-05-15', 'Erkek', '5551234567', 'ahmet@example.com', 1, 1, 'sifre123', 1, 0),
(2, '23456789012', 'Ayşe', 'Kaya', '1985-10-20', 'Kadın', '5552345678', 'ayse@example.com', 2, 2, 'sifre456', 1, 1),
(3,'34567890123', 'Mehmet', 'Demir', '1995-03-10', 'Erkek', '7777777777', 'mehmet@example.com', 3, 3, 'mehmet789',1,0),
(4,'39567890124', 'Asya', 'Deniz', '1995-06-10', 'Erkek', '5552345679', 'ali@example.com', 3, 3, 'ali789',1,0),
(5,'38567890125', 'Zeynep', 'Miran', '1999-12-10', 'Kadın', '7111111111', 'zeynep@example.com', 3, 3, 'zeynep789',1,0),
(6,'37567890126', 'Esma', 'Demir', '2001-03-10', 'Kadın', '9999007777', 'esma@example.com', 3, 3, 'esma789',1,0),
(7,'36567890127', 'Mehmet', 'Çelik', '1988-01-11', 'Erkek', '7777711111', 'mehmet@example.com', 3, 3, 'mehmet789',1,0),
(8,'35567890128', 'Zeliha', 'Ses', '2004-12-10', 'Kadın', '1777777777', 'zeliha@example.com', 3, 3, 'zeliha789',1,0),
(9,'34567890129', 'Sena', 'Nur', '1998-10-10', 'Kadın', '1117777777', 'sena@example.com', 3, 3, 'sena789',1,0),
(10,'33567890120', 'Ramazan', 'Mete', '2007-03-10', 'Erkek', '7777222777', 'ramazan@example.com', 3, 3, 'ramazan789',1,0),
(11,'32567890121', 'Semanur', 'Gören', '1999-07-10', 'Kadın', '7555777777', 'semanur@example.com', 3, 3, 'semanur789',1,1),
(12,'31567890122', 'Taha', 'Kaplan', '2010-09-10', 'Erkek', '7770007777', 'taha@example.com', 3, 3, 'taha89',1,0);
END;

--*******************************************
IF NOT EXISTS (SELECT * FROM tblBilet)
BEGIN
    -- Veri Ekleme
    INSERT INTO tblBilet (ID, UYE_ID, SEANS_ID, KOLTUK_ID, SALON_ID ,PERSONEL_ID ,UCRET_ID ,FIYAT, TARIH, GUN_ID)
    VALUES 
    (1, 1, 1, 1, 1, 1, 1, 600, '2023-10-10', 1),
    (2, 2, 2, 2, 2, 2, 2, 540, '2023-02-02', 2),
    (3, 2, 3, 3, 3, 3, 3, 510, '2023-05-06', 3),
    (4, 3, 4, 4, 3, 4, 4, 750, '2023-11-11', 4),
    (5, 4, 5, 5, 4, 3, 5, 900, '2023-12-12', 5),
    (6, 5, 4, 6, 5, 2, 6, 1250, '2023-01-01', 6),
    (7, 5, 3, 7, 6, 1, 7, 1170, '2023-03-03', 7),
    (8, 5, 2, 8, 7, 2, 8, 400, '2023-07-06', 8),
    (9, 6, 1, 9, 8, 3, 9, 830, '2023-02-06', 9),
    (10, 4, 1, 10, 9, 4, 10, 750, '2023-03-06', 10),
    (11, 4, 2, 11, 10, 3,11, 1210, '2023-04-06', 11),
    (12, 5, 3, 13, 9, 2, 10, 750, '2023-05-05', 12),
    (13, 7, 4, 12, 8, 4, 9, 830, '2023-10-06', 13),
    (14, 8, 3, 14, 7, 1, 8, 400, '2023-09-06', 14),
    (15, 9, 3, 15, 6, 3, 7, 1170, '2023-03-02', 14),
    (16, 6, 2, 16, 5, 2, 6, 1250, '2024-03-03', 13),
    (17, 2, 1, 17, 4, 1, 5, 900, '2024-01-03', 12),
    (18, 1, 2, 18, 3, 2, 4, 750, '2024-05-01', 11),
    (19, 3, 5, 19, 2, 3, 3, 660, '2024-07-05', 10),
    (20, 2, 5, 20, 1, 4, 2, 540, '2024-08-06', 9),
    (21, 4, 5, 23, 2, 3, 1, 600, '2024-09-07', 8),
    (22, 4, 4, 21, 3, 4, 2, 360, '2024-02-08', 7),
    (23, 5, 2, 22, 4, 3, 2, 540, '2024-03-09', 6),
    (24, 11, 5, 42, 5, 2, 3, 510, '2024-04-10', 5),
    (25, 2, 6, 41, 6, 2, 11, 1160, '2024-07-17', 6),
    (26, 12, 7, 15, 7, 3, 2, 540, '2024-06-14', 10),
    (27, 1, 8, 27, 8, 4, 8, 400, '2024-04-06', 11),
    (28, 3, 9, 21, 9, 1, 9, 670, '2024-01-10', 5),
    (29, 4, 8, 32, 10, 2, 7, 970, '2024-10-25', 9),
    (30, 6, 6, 49, 5, 3, 6, 1250, '2024-01-03', 6),
    (31, 1, 1, 38, 6, 3, 6, 1000, '2024-02-04', 13),
    (32, 2, 2, 29, 7, 1, 11, 1210, '2024-03-11', 1),
    (33, 3, 3, 36, 8, 2, 6, 1250, '2024-04-15', 2),
    (34, 4, 4, 15, 9, 3, 10, 900, '2024-05-08', 5),
    (35, 5, 5, 13, 10, 4, 5, 900, '2024-01-09', 4),
    (36, 6, 14, 46, 9, 4, 6, 1250, '2024-11-09', 11),
    (37, 7, 13, 47, 8, 3, 11, 1210, '2024-11-19', 4),
    (38, 8, 12, 48, 7, 2, 1, 600, '2024-08-28', 5),
    (39, 9, 11, 49, 6, 1, 2, 540, '2024-05-10', 9),
    (40, 10, 10, 50, 5, 4, 3, 510, '2024-12-12', 8),
    (41, 9, 16, 50, 4, 4, 5, 900, '2024-11-11', 1),
    (42, 8, 17, 49, 3, 1, 6, 1250, '2024-10-10', 7),
    (43, 12, 18, 30, 2, 2, 11, 1210, '2024-09-09', 2),
    (44, 7, 19, 20, 1, 3, 6, 1250, '2024-08-12', 1),
    (45, 6, 20, 10, 5, 4, 5, 900, '2024-07-11', 8),
    (46, 7, 21, 48, 9, 4, 6, 1250, '2024-01-12', 9),
    (47, 8, 22, 16, 8, 3, 7, 1170, '2024-02-13', 3),
    (48, 5, 23, 24, 7, 2, 8, 400, '2024-03-14', 8),
    (49, 10, 24, 36, 6, 1, 9, 830, '2024-04-15', 13),
    (50, 11, 25, 42, 5, 4, 10, 900, '2024-05-16', 7),
    (51, 10, 1, 11, 3, 4, 11, 1210, '2024-06-11', 3),
    (52, 2, 3, 22, 4, 1, 10, 900, '2024-07-12', 9),
    (53, 8, 8, 32, 5, 2, 9, 770, '2024-08-13', 4),
    (54, 1, 20, 48, 6, 3, 8, 700, '2024-09-14', 11),
    (55, 7, 21, 47, 11, 4, 7, 1170, '2024-10-15', 3);

END;