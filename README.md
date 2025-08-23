# 🎬 Sinema Bilet Satış Sistemi

> Modern sinema işletmeleri için tasarlanmış, kapsamlı ve kullanıcı dostu bilet satış sistemi

## 📋 İçindekiler

- [Genel Bakış](#-genel-bakış)
- [Özellikler](#-özellikler)
- [Teknolojiler](#-teknolojiler)
- [Kurulum](#-kurulum)
- [Veritabanı Yapısı](#-veritabanı-yapısı)
- [Kullanım Örnekleri](#-kullanım-örnekleri)
- [Katkıda Bulunma](#-katkıda-bulunma)
- [Lisans](#-lisans)
- [İletişim](#-iletişim)

## 🎯 Genel Bakış

Bu proje, modern sinema işletmelerinin tüm ihtiyaçlarını karşılayacak şekilde tasarlanmış, tam özellikli bir bilet satış sistemi veritabanıdır. Film yönetiminden bilet satışına, müşteri takibinden finansal analizlere kadar sinema işletmeciliğinin her alanını kapsayan normalize edilmiş bir veritabanı yapısı sunar.

### 🚀 Neden Bu Proje?

- **Kapsamlı Çözüm**: Sinema işletmeciliğinin tüm süreçlerini tek platformda yönetim
- **Ölçeklenebilir Tasarım**: Tek salondan büyük sinema zincirlerine kadar genişleyebilir
- **Modern Yaklaşım**: Güncel veritabanı tasarım prensipleri ve normalizasyon kuralları
- **Açık Kaynak**: MIT lisansı ile ücretsiz kullanım ve geliştirme

## ✨ Özellikler

### 🎭 Film Yönetimi
- **Detaylı Film Bilgileri**: Ad, tür, süre, yönetmen, oyuncular
- **Medya Yönetimi**: Film posterleri ve tanıtım metinleri
- **Kategorizasyon**: Yaş sınırı ve dil seçenekleri
- **Format Desteği**: 2D, 3D, IMAX gibi farklı gösterim formatları

### 🏢 Salon ve Seans Yönetimi
- **Çoklu Salon Desteği**: Sınırsız salon ekleme imkanı
- **Esnek Koltuk Düzeni**: Her salon için özelleştirilebilir koltuk haritası
- **Dinamik Seans Programlama**: Farklı saatlerde esnek programlama
- **Kapasite Kontrolü**: Otomatik doluluk hesaplama

### 🎫 Akıllı Bilet Sistemi
- **Online Rezervasyon**: Web tabanlı bilet satış altyapısı
- **Koltuk Seçimi**: Görsel koltuk haritası ile seçim
- **Fiyat Kategorileri**: Öğrenci, tam bilet, indirimli fiyatlar
- **İptal ve İade**: Esnek iptal politikaları

### 👤 Müşteri Deneyimi
- **Kullanıcı Profilleri**: Detaylı müşteri bilgi yönetimi
- **Satın Alma Geçmişi**: Geçmiş işlem takibi
- **Sadakat Programı**: Puan toplama ve kullanma sistemi
- **Kişiselleştirme**: Müşteri tercih analizi

### 💰 İş Analitikleri
- **Gerçek Zamanlı Raporlar**: Günlük, haftalık, aylık satış analizleri
- **Gelir Optimizasyonu**: Fiyatlandırma ve kapasite analizleri
- **Trend Analizi**: Film popülaritesi ve müşteri davranış analizi
- **Finansal Kontrol**: Detaylı muhasebe ve raporlama

## 🛠 Teknolojiler

- **Veritabanı**: MySQL 5.7+ / PostgreSQL 10+
- **Tasarım**: ER Modeling, Normalizasyon (1NF, 2NF, 3NF)
- **Güvenlik**: Primary/Foreign Key ilişkileri, Referential Integrity
- **Performans**: Optimized indexing, Query optimization

## 🚀 Kurulum

### Gereksinimler

```bash
# Gerekli yazılımlar
- MySQL 5.7+ veya PostgreSQL 10+
- SQL Management Tool (phpMyAdmin, MySQL Workbench, DBeaver vb.)
- Git
```

### Hızlı Başlangıç

1. **Repository'yi klonlayın**
```bash
git clone https://github.com/elifnuroksuzz/BiletSatisSinema.git
cd BiletSatisSinema
```

2. **Veritabanını oluşturun**
```sql
CREATE DATABASE sinema_bilet_satis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sinema_bilet_satis;
```

3. **Şemayı ve örnek verileri yükleyin**
```bash
# Ana tablo yapısı
mysql -u [kullanici_adi] -p sinema_bilet_satis < database/schema.sql

# Örnek veriler (isteğe bağlı)
mysql -u [kullanici_adi] -p sinema_bilet_satis < database/sample_data.sql
```

4. **Bağlantıyı test edin**
```sql
-- Kurulumu doğrulama
SHOW TABLES;
SELECT COUNT(*) FROM filmler;
```

## 🗂️ Veritabanı Yapısı

### Ana Tablolar ve İlişkiler

| Tablo | Primary Key | Açıklama | İlişkiler |
|-------|-------------|----------|-----------|
| `filmler` | `film_id` | Film bilgileri ve detayları | → seanslar |
| `salonlar` | `salon_id` | Sinema salon bilgileri | → seanslar, koltuklar |
| `seanslar` | `seans_id` | Film gösterim seansları | filmler ← → biletler |
| `koltuklar` | `koltuk_id` | Salon koltuk düzenleri | salonlar ← → biletler |
| `musteriler` | `musteri_id` | Müşteri profil bilgileri | → biletler, odemeler |
| `biletler` | `bilet_id` | Satılan bilet kayıtları | musteriler, seanslar, koltuklar ← |
| `odemeler` | `odeme_id` | Ödeme işlem kayıtları | biletler ← |
| `calisanlar` | `calisan_id` | Personel bilgi sistemi | → biletler |

### ER Diyagram Özellikleri

- ✅ **Normalizasyon**: 1NF, 2NF, 3NF kurallarına uygun
- ✅ **Referential Integrity**: Veri bütünlüğü korunması
- ✅ **Scalability**: Büyük veri setleri için optimize edilmiş
- ✅ **Performance**: İndexler ve sorgu optimizasyonu

## 💡 Kullanım Örnekleri

### Film ve Seans Yönetimi

```sql
-- Yeni film ekleme
INSERT INTO filmler (ad, tur, sure, yonetmen, yas_siniri, dil, format) 
VALUES ('Avatar: Su Yolu', 'Bilim Kurgu', 192, 'James Cameron', '13+', 'TR', '3D');

-- Seans programlama
INSERT INTO seanslar (film_id, salon_id, tarih, saat, fiyat) 
VALUES (1, 1, '2024-01-15', '20:00', 35.00);

-- Mevcut seansları görüntüleme
SELECT f.ad as film_adi, s.salon_adi, se.tarih, se.saat, se.fiyat
FROM seanslar se
JOIN filmler f ON se.film_id = f.film_id
JOIN salonlar s ON se.salon_id = s.salon_id
WHERE se.tarih >= CURDATE();
```

### Bilet Satış ve Rezervasyon

```sql
-- Bilet satışı
INSERT INTO biletler (musteri_id, seans_id, koltuk_id, fiyat, durum) 
VALUES (123, 456, 789, 35.00, 'SATIN_ALINDI');

-- Mevcut rezervasyonları kontrol
SELECT k.sira, k.numara, b.durum
FROM koltuklar k
LEFT JOIN biletler b ON k.koltuk_id = b.koltuk_id AND b.seans_id = 456
WHERE k.salon_id = 1;
```

### Raporlama ve Analiz

```sql
-- Günlük satış raporu
SELECT DATE(b.satin_alma_tarihi) as tarih, COUNT(*) as bilet_sayisi, SUM(b.fiyat) as toplam_gelir
FROM biletler b
WHERE DATE(b.satin_alma_tarihi) = CURDATE()
GROUP BY DATE(b.satin_alma_tarihi);

-- En popüler filmler
SELECT f.ad, COUNT(b.bilet_id) as satis_adedi
FROM filmler f
JOIN seanslar s ON f.film_id = s.film_id
JOIN biletler b ON s.seans_id = b.seans_id
GROUP BY f.film_id
ORDER BY satis_adedi DESC
LIMIT 10;
```

## 📊 Demo ve Örnekler

Projeyi test etmek için örnek veriler dahil edilmiştir:

- **10 örnek film** (farklı türlerde)
- **3 salon** (farklı kapasitelerde)
- **50+ seans** (bir haftalık program)
- **100+ müşteri** profili
- **200+ bilet** satış örneği

## 🤝 Katkıda Bulunma

Bu projeye katkıda bulunmak istiyorsanız:

1. **Fork** yapın ve yerel kopyanızı oluşturun
2. **Feature branch** oluşturun: `git checkout -b yeni-ozellik`
3. **Değişikliklerinizi commit** edin: `git commit -m 'Yeni özellik: Detaylı açıklama'`
4. **Branch'inizi push** edin: `git push origin yeni-ozellik`
5. **Pull Request** oluşturun

### Katkı Rehberi

- **Bug Report**: Hata bulduğunuzda [Issues](https://github.com/elifnuroksuzz/BiletSatisSinema/issues) sayfasından bildirin
- **Feature Request**: Yeni özellik önerilerinizi paylaşın
- **Code Style**: Mevcut kod stiline uygun geliştirme yapın
- **Documentation**: Yaptığınız değişiklikleri dokümante edin

## 📝 Lisans

Bu proje [MIT Lisansı](https://choosealicense.com/licenses/mit/) ile lisanslanmıştır.


## 👩‍💻 İletişim

**Elif Nur Öksüz**

- 🌐 **GitHub**: [@elifnuroksuzz](https://github.com/elifnuroksuzz)
- 📧 **Email**: [elifnuroksuz4@gmail.com](mailto:elifnuroksuz4@gmail.com)
- 💼 **LinkedIn**: [elifnuroksuz](https://www.linkedin.com/in/elifnuroksuz/)
- 🐛 **Issues**: [Proje Issues Sayfası](https://github.com/elifnuroksuzz/BiletSatisSinema/issues)

## 🙏 Teşekkürler

Bu projeyi kullanan ve geliştiren herkese teşekkürler! Özellikle:


---

⭐ **Bu projeyi beğendiyseniz yıldızlamayı unutmayın!**

🐛 **Hata mı buldunuz?** [Issues sayfasından](https://github.com/elifnuroksuzz/BiletSatisSinema/issues) bize bildirin.

🔄 **Güncellemeler için** bu repository'yi takip edin!

---

