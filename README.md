# 🎬 Sinema Bilet Satış Sistemi

Kapsamlı bir sinema bilet satış sistemi için tasarlanmış veritabanı projesi. Bu proje, modern sinema işletmelerinin ihtiyaçlarını karşılamak üzere geliştirilmiş ER diyagramı ve veritabanı yapısını içermektedir.

## ✨ Özellikler

🎭 **Film Yönetimi**
- Film bilgileri (ad, tür, süre, yönetmen, oyuncular)
- Film posterleri ve açıklamaları
- Yaş sınırı ve dil seçenekleri

🏢 **Salon ve Seans Yönetimi**
- Çoklu salon desteği
- Koltuk düzenleri ve kapasiteler
- Flexible seans programlama
- Farklı film formatları (2D, 3D, IMAX)

🎫 **Bilet Rezervasyon Sistemi**
- Online bilet satışı
- Koltuk seçimi ve rezervasyon
- Fiyat kategorileri (öğrenci, tam, indirimli)
- Bilet iptali ve iade işlemleri

👤 **Müşteri Yönetimi**
- Kullanıcı kayıt ve giriş sistemi
- Müşteri profil bilgileri
- Satın alma geçmişi
- Sadakat puanları

💰 **Finansal Takip**
- Satış raporları
- Gelir analizi
- Kasa ve ödeme yöntemleri
- İndirim ve kampanya yönetimi

## 🗂️ Veritabanı Yapısı

### Ana Tablolar

| Tablo | Açıklama |
|-------|----------|
| `filmler` | Film bilgileri ve detayları |
| `salonlar` | Sinema salonları ve özellikleri |
| `seanslar` | Film gösterim seansları |
| `koltuklar` | Salon koltuk düzenleri |
| `musteriler` | Müşteri bilgileri |
| `biletler` | Satılan bilet kayıtları |
| `odemeler` | Ödeme işlemleri |
| `calisanlar` | Personel bilgileri |

## 🚀 Kurulum

### Gereksinimler
- MySQL 5.7+ veya PostgreSQL 10+
- SQL Management Tool (phpMyAdmin, MySQL Workbench, vb.)

### Adım Adım Kurulum

1. **Repository'yi klonlayın:**
```bash
git clone https://github.com/elifnuroksuzz/BiletSatisSinema.git
cd BiletSatisSinema
```

2. **Veritabanını oluşturun:**
```sql
CREATE DATABASE sinema_bilet_satis;
USE sinema_bilet_satis;
```

3. **Tabloları oluşturun:**
```bash
# SQL dosyalarını sırayla çalıştırın
mysql -u username -p sinema_bilet_satis < database_schema.sql
mysql -u username -p sinema_bilet_satis < sample_data.sql
```

## 📊 ER Diyagramı

Proje, normalize edilmiş veritabanı tasarımı prensiplerine uygun olarak tasarlanmıştır:

- **1NF, 2NF, 3NF** kurallarina uygun normalizasyon
- **Primary Key** ve **Foreign Key** ilişkileri
- **One-to-Many** ve **Many-to-Many** ilişki türleri
- **Referential Integrity** korunması

## 💡 Örnek Kullanım Senaryoları

### 🎬 Film Programlama
```sql
-- Yeni film ekleme
INSERT INTO filmler (ad, tur, sure, yonetmen, yas_siniri) 
VALUES ('Avatar: Su Yolu', 'Bilim Kurgu', 192, 'James Cameron', '13+');

-- Seans oluşturma
INSERT INTO seanslar (film_id, salon_id, tarih, saat, fiyat) 
VALUES (1, 1, '2024-01-15', '20:00', 35.00);
```

### 🎫 Bilet Satışı
```sql
-- Bilet rezervasyonu
INSERT INTO biletler (musteri_id, seans_id, koltuk_id, fiyat, durum) 
VALUES (123, 456, 789, 35.00, 'SATIN_ALINDI');
```

## 📈 Raporlama Özellikleri

- **Günlük/Aylık satış raporları**
- **En popüler filmler analizi**
- **Salon doluluk oranları**
- **Müşteri demografik analizleri**
- **Gelir trend analizleri**

## 🔧 Teknik Özellikler

- **Ölçeklenebilir tasarım:** Büyük sinema zincirleri için uygun
- **Performans optimizasyonu:** İndexler ve query optimizasyonu
- **Veri bütünlüğü:** Constraint'ler ve trigger'lar
- **Güvenlik:** Kullanıcı rolleri ve yetkilendirme

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Değişiklikleri commit edin (`git commit -am 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/yeni-ozellik`)
5. Pull Request oluşturun

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 👩‍💻 Geliştirici

**Elif Nur Öksüz**
- GitHub: [@elifnuroksuzz](https://github.com/elifnuroksuzz)
- Email: [elifnuroksuz4@gmail.com]
- Linkldln [https://www.linkedin.com/in/elifnuroksuz/]

## 🙏 Teşekkürler

Bu projeyi geliştirirken yardımcı olan herkese teşekkür ederiz!

---

⭐ Bu projeyi beğendiyseniz yıldızlamayı unutmayın!

🐛 Hata bulursanız veya öneriniz varsa [Issues](https://github.com/elifnuroksuzz/BiletSatisSinema/issues) sayfasından bize ulaşın.
