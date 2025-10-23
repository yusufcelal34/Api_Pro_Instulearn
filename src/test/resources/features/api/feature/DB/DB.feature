@DB
Feature: BACKEND JDBC TESTING

  # Bu feature, JDBC ile MySQL üzerinde doğrulama ve veri işleme senaryolarını içerir.
  # Her senaryo: Bağlantı -> Sorgu/İşlem -> Doğrulama -> Bağlantıyı kapat akışını izler.

  Background: Database connection
    # Test başlangıcında DB bağlantısı kuruluyor
    * Database connection is established.

  # @DB01 — categories: slug='fashion' olan kaydın name değerini doğrula
  @DB01
  Scenario: US01 Verify name for slug=fashion in categories
    # İlgili kategori tekil/benzersiz varsayılmıştır
    * Query is prepared and executed: select name by slug
    * Verify the "name" field in result
    * Database connection is closed
    """
    -- Kategori adını slug'a göre getir
    SELECT name FROM categories WHERE slug='fashion';
    """

  # @DB02 — cities tablosuna ekleme ve eklendiğini doğrulama
  @DB02
  Scenario: US02 Insert into cities and verify
    # Parametreler: :id, :name, :state_id, :status (runner tarafından verilir)
    * Insert data to the cities table
    * Select by primary key to verify inserted row
    * Database connection is closed
    """
    -- Yeni şehir ekle
    INSERT INTO cities(id,name,state_id,status,created_at)
    VALUES(:id,:name,:state_id,:status,NOW());
    -- Eklenen şehri doğrula
    SELECT * FROM cities WHERE id=:id;
    """

  # @DB03 — cities kaydı silme ve silindiğini doğrulama
  @DB03
  Scenario: US03 Delete from cities and verify
    # Silmeden önce kayıt var mı garanti etmek için upsert uygulanır
    * Ensure row exists (insert if needed)
    * Delete target row
    * Verify row count is 0
    * Database connection is closed
    """
    -- Varsa güncelle, yoksa ekle (test id/name ile)
    INSERT INTO cities(id,name,state_id,status,created_at)
    VALUES(:id,:name,1,1,NOW())
    ON DUPLICATE KEY UPDATE name=VALUES(name);
    -- Sil ve doğrula
    DELETE FROM cities WHERE id=:id AND name=:name;
    SELECT COUNT(*) cnt FROM cities WHERE id=:id AND name=:name;
    """

  # @DB04 — contacts ekleme ve message alanını update etme
  @DB04
  Scenario: US04 Insert contact and update message
    # Aynı id/email ile önce ekle, sonra message değerini güncelle
    * Insert contact row
    * Update message by id/email
    * Verify updated value
    * Database connection is closed
    """
    -- İletişim kaydı ekle
    INSERT INTO contacts(id,name,email,query_type,message)
    VALUES(:id,:name,:email,:qtype,:msg);
    -- Mesajı güncelle
    UPDATE contacts SET message=:new_msg WHERE id=:id OR email=:email;
    -- Güncellenen değeri doğrula
    SELECT message FROM contacts WHERE id=:id;
    """

  # @DB05 — contacts ekle ve email ile sil
  @DB05
  Scenario: US05 Insert then delete contact by email
    # Test izolasyonu için case kendi verisini ekler ve siler
    * Insert contact row
    * Delete by email
    * Verify deletion
    * Database connection is closed
    """
    -- Ekle
    INSERT INTO contacts(id,name,email,query_type,message)
    VALUES(:id,:name,:email,:qtype,:msg);
    -- Email ile sil
    DELETE FROM contacts WHERE email=:email;
    -- Kayıt kalmadığını doğrula
    SELECT COUNT(*) AS cnt FROM contacts WHERE email=:email;
    """

  # @DB06 — kupon başına ürün sayısı
  @DB06
  Scenario: US06 Count products per coupon
    # Gruplama ile her kuponun ilişkilendiği ürün sayısı hesaplanır
    * Run grouped count by coupon_id
    * Verify grouped result
    * Database connection is closed
    """
    -- Kupon bazında ürün adedi
    SELECT coupon_id, COUNT(*) AS product_count
    FROM coupon_products
    GROUP BY coupon_id;
    """

  # @DB07 — (bilerek boş bırakıldı; başlık verildiğinde eklenecek)
  @DB07
  Scenario: US07
    # Yer tutucu senaryo (ihtiyaca göre doldurulacak)

  # @DB08 — delivery_processes: son 5 kaydın isimleri ters sıra kontrolü
  @DB08
  Scenario: US08 Verify first 5 names in reverse order
    # Beklenen dizi: Shipped, Recieved, Processing, Pending, Delivered
    * Fetch first 5 by created/id desc
    * Assert order equals [Shipped, Recieved, Processing, Pending, Delivered]
    * Database connection is closed
    """
    -- Son 5 süreç adı (id azalan)
    SELECT name FROM delivery_processes
    ORDER BY id DESC
    LIMIT 5;
    """

  # @DB09 — log_activity: belirli IP ve method='Delete' sayımı
  @DB09
  Scenario: US09 Count topics by ip and method
    # Belirli bir IP üzerinden Delete işlem adedi ölçülür
    * Execute count query
    * Verify count > 0 (veya beklenen sabit değer)
    * Database connection is closed
    """
    -- IP ve method filtresiyle toplam
    SELECT COUNT(*) AS delete_count
    FROM log_activity
    WHERE ip='46.2.239.35' AND method='Delete';
    """

  # @DB10 — order_address_details: shipping != billing olanlar
  @DB10
  Scenario: US10 Count users with different shipping/billing
    # Null senaryosunu da kapsamak için XOR benzeri kontrol eklenmiştir
    * Run mismatch query
    * Verify count
    * Database connection is closed
    """
    -- Farklı veya biri NULL diğeri değilse
    SELECT COUNT(*) AS diff_cnt
    FROM order_address_details
    WHERE shipping_address <> billing_address
          OR (shipping_address IS NULL) <> (billing_address IS NULL);
    """

  # @DB11 — wallet_balances: type='Referral' ve id 10–20 toplam
  @DB11
  Scenario: US11 Sum amount for Referral in id range
    # COALESCE ile boş sonuçta 0 döndürülür
    * Execute sum query
    * Verify sum result
    * Database connection is closed
    """
    -- Id aralığında Referral toplamı
    SELECT COALESCE(SUM(amount),0) AS total_amount
    FROM wallet_balances
    WHERE type='Referral' AND id BETWEEN 10 AND 20;
    """

  # @DB12 — attendances: benzersiz notları günlere göre birleştir
  @DB12
  Scenario: US12 List unique notes grouped by day
    # Aynı gün içindeki farklı notlar tek satırda toplanır
    * Execute distinct notes by DATE(created_at)
    * Verify uniqueness per day
    * Database connection is closed
    """
    -- Gün bazında not listesi
    SELECT DATE(created_at) AS day, GROUP_CONCAT(DISTINCT note ORDER BY note) AS notes
    FROM attendances
    WHERE note IS NOT NULL AND note <> ''
    GROUP BY DATE(created_at);
    """

  # @DB13 — seller_products: kupon ilişkisi olmayan ilk 3 ürün
  @DB13
  Scenario: US13 First 3 products with no coupon relation
    # Kuponla eşleşmeyen ürünleri NOT EXISTS ile seç
    * Run anti-join / NOT EXISTS
    * Verify 3 rows (varsa)
    * Database connection is closed
    """
    -- Kuponu olmayan ürünler
    SELECT sp.id, sp.product_id
    FROM seller_products sp
    WHERE NOT EXISTS (
      SELECT 1 FROM coupon_products cp WHERE cp.product_id = sp.product_id
    )
    ORDER BY sp.id
    LIMIT 3;
    """

  # @DB14 — refund_reasons: reason NULL var mı?
  @DB14
  Scenario: US14 Check NULL reason exists in refund_reasons
    # Veri kalitesi kontrolü; NULL sayısı beklenenden farklıysa raporlanır
    * Execute null-check query
    * Verify count
    * Database connection is closed
    """
    -- NULL reason sayısı
    SELECT COUNT(*) AS null_cnt
    FROM refund_reasons
    WHERE reason IS NULL;
    """

  # @DB15 — customer_coupon_stores ilk 3 kaydı users ile birlikte
  @DB15
  Scenario: US15 First 3 customer_coupon_stores with users
    # Kullanıcı kimlik bilgileriyle zenginleştirilmiş liste
    * Join to users and fetch 3 rows
    * Verify columns
    * Database connection is closed
    """
    -- İlk 3 kayıt ve kullanıcı bilgileri
    SELECT ccs.id, ccs.user_id, u.first_name, u.last_name, u.email
    FROM customer_coupon_stores ccs
    JOIN users u ON u.id = ccs.user_id
    ORDER BY ccs.id
    LIMIT 3;
    """

  # @DB16 — Switzerland kargolu adres kayıtlarının id’leri (orders ile)
  @DB16
  Scenario: US16 List ids with shipping_address='Switzerland' using orders
    # orders join'u, order bağlılığını doğrulamak için eklenmiştir
    * Join orders if gerekli
    * Verify at least 3 rows (opsiyonel)
    * Database connection is closed
    """
    -- İsviçre gönderimli adresler
    SELECT oad.id
    FROM order_address_details oad
    JOIN orders o ON oad.order_id = o.id
    WHERE oad.shipping_address='Switzerland';
    """

  # @DB17 — 2022'den önceki attendance’lardan user id=5 e‑posta doğrulama
  @DB17
  Scenario: US17 Verify email of user id=5 from pre-2022 attendances
    # Tekil e‑posta beklenir; birden fazla ise DISTINCT ile tekilleştirilir
    * Fetch user email via join & date filter
    * Assert email equals expected
    * Database connection is closed
    """
    -- 2022 öncesi katılımlardan kullanıcı e‑postası
    SELECT DISTINCT u.email
    FROM attendances a
    JOIN users u ON u.id = a.user_id
    WHERE a.created_at < '2022-01-01' AND u.id = 5;
    """

  # @DB18 — bank_accounts: 5 adet toplu ekle ve doğrula
  @DB18
  Scenario: US18 Bulk insert 5 bank_accounts and verify
    # Test kapsamı için sahte banka kayıtları ekleniyor (ad/numara/başlangıç bakiye)
    * Insert 5 rows
    * Verify affected rows = 5
    * Database connection is closed
    """
    -- 5 satır ekle
    INSERT INTO bank_accounts(bank_name,account_no,opening_balance,created_at)
    VALUES
      ('B1','ACC1',1000,NOW()),
      ('B2','ACC2',2000,NOW()),
      ('B3','ACC3',3000,NOW()),
      ('B4','ACC4',4000,NOW()),
      ('B5','ACC5',5000,NOW());
    -- Eklendi mi kontrol
    SELECT COUNT(*) AS cnt
    FROM bank_accounts
    WHERE bank_name IN ('B1','B2','B3','B4','B5');
    """

  # @DB19 — opening_balance negatif güncellenemez (bütünlük kontrolü)
  @DB19
  Scenario: US19 opening_balance must not update to negative
    # CHECK/trigger varsa 0 affected beklenir; yoksa test bunu ihlal olarak raporlar
    * Try update with negative and expect 0 affected or constraint error
    * Verify value unchanged
    * Database connection is closed
    """
    -- Negatif değere güncellemeyi dene
    UPDATE bank_accounts SET opening_balance=-1 WHERE bank_name=:bank_name;
    -- Mevcut değeri kontrol et
    SELECT opening_balance FROM bank_accounts WHERE bank_name=:bank_name;
    """

  # @DB20 — device_tokens: aynı anda 10 kayıt ve doğrulama
  @DB20
  Scenario: US20 Bulk insert 10 device_tokens and verify
    # Kolaylık için tüm tokenlar UUID ile üretilir; user_id sabittir
    * Insert 10 rows (UUID/device/created_at)
    * Verify count of inserted keys
    * Database connection is closed
    """
    -- 10 satır ekle
    INSERT INTO device_tokens(user_id,device,token,created_at)
    VALUES
      (1,'ios',UUID(),NOW()),(1,'ios',UUID(),NOW()),
      (1,'ios',UUID(),NOW()),(1,'ios',UUID(),NOW()),
      (1,'ios',UUID(),NOW()),(1,'ios',UUID(),NOW()),
      (1,'ios',UUID(),NOW()),(1,'ios',UUID(),NOW()),
      (1,'ios',UUID(),NOW()),(1,'ios',UUID(),NOW());
    -- Bugün eklenen satır sayısı
    SELECT COUNT(*) AS cnt
    FROM device_tokens
    WHERE user_id=1 AND DATE(created_at)=CURRENT_DATE();
    """

  # @DB21 — guest_order_details: bir order_id için adet ve shipping_name güncelle
  @DB21
  Scenario: US21 Count by order_id and update shipping_name
    # Örnek için :order_id ve :new_name parametreleri kullanılır
    * Count items for :order_id
    * Update shipping_name for order_id=:order_id
    * Database connection is closed
    """
    -- Sipariş satır adedi
    SELECT order_id, COUNT(*) AS item_count
    FROM guest_order_details
    WHERE order_id=:order_id
    GROUP BY order_id;
    -- Kargo adını güncelle
    UPDATE guest_order_details
    SET shipping_name=:new_name
    WHERE order_id=:order_id;
    """

  # @DB22 — digital_gift_cards: ekle ve aynı id ile sil
  @DB22
  Scenario: US22 Insert one digital_gift_card then delete by id
    # LAST_INSERT_ID ile eklenen kaydın id'si yakalanır ve silinir
    * Insert row and capture id
    * Delete same id
    * Verify deletion
    * Database connection is closed
    """
    -- Kart ekle
    INSERT INTO digital_gift_cards(user_id,code,amount,expires_at,created_at)
    VALUES(:user_id,UUID(),:amount,NOW()+INTERVAL 30 DAY,NOW());
    -- Eklenen id
    SET @new_id = LAST_INSERT_ID();
    -- Sil ve doğrula
    DELETE FROM digital_gift_cards WHERE id=@new_id;
    SELECT COUNT(*) cnt FROM digital_gift_cards WHERE id=@new_id;
    """

  # @DB23 — email_template_types: module NOT NULL → type bazında sayım
  @DB23
  Scenario: US23 Count types where module is not null
    # Rapor: type kırılımında kaç adet kayıt var
    * Group by type and count
    * Database connection is closed
    """
    -- Modülü dolu olan tipler ve adetleri
    SELECT type, COUNT(*) AS type_count
    FROM email_template_types
    WHERE module IS NOT NULL
    GROUP BY type;
    """

  # @DB24 — orders: email '%customer%' içermesin ve sub_total < 2000; order_number DESC
  @DB24
  Scenario: US24 Filter orders by email & subtotal, order_number desc
    # İsteğe bağlı: belirli sayıda satır dönmesi beklenebilir (örn. 30)
    * Run query
    * Optionally assert returned row count
    * Database connection is closed
    """
    -- Filtreler ve sıralama
    SELECT id, order_number, customer_email, sub_total
    FROM orders
    WHERE customer_email NOT LIKE '%customer%'
      AND sub_total < 2000
    ORDER BY order_number DESC;
    """

  # @DB25 — order_payments: txn_id!='none' → MAX(amount)>9000, azalan
  @DB25
  Scenario: US25 Group by txn_id: max_amount > 9000 sorted
    # Büyük tutarlı ödemeler öne alınır
    * Execute aggregation and verify sort
    * Database connection is closed
    """
    -- İşlem kimliği bazında en yüksek ödeme
    SELECT txn_id, MAX(amount) AS max_amount
    FROM order_payments
    WHERE txn_id <> 'none'
    GROUP BY txn_id
    HAVING MAX(amount) > 9000
    ORDER BY max_amount DESC;
    """

  # @DB26 — transactions: payment_method kırılımı, toplam > 7000 ve alfabetik ters
  @DB26
  Scenario: US26 Sum by payment_method and filter >7000
    # Sıralama, yöntem adına göre DESC istenir
    * Execute grouped sum
    * Verify sort by payment_method DESC
    * Database connection is closed
    """
    -- Ödeme yöntemine göre toplam
    SELECT payment_method, SUM(amount) AS total_amount
    FROM transactions
    GROUP BY payment_method
    HAVING SUM(amount) > 7000
    ORDER BY payment_method DESC;
    """

  # @DB27 — transactions: iki yöntem için benzersiz description listesi
  @DB27
  Scenario: US27 Unique descriptions for two payment methods
    # Boş/NULL açıklamalar hariç tutulur
    * Fetch distinct descriptions
    * Database connection is closed
    """
    -- Stripe ve Kapıda Ödeme açıklamaları (tekrarsız)
    SELECT DISTINCT description
    FROM transactions
    WHERE payment_method IN ('Stripe','Cash On Delivery')
      AND description IS NOT NULL AND description <> '';
    """

  # @DB28 — support_tickets: reference_no '-' içeren/içermeyen → user_id setleri
  @DB28
  Scenario: US28 Unique user_ids by reference_no pattern
    # İki ayrı sonuç kümesi alınır
    * Two sets: with dash / without dash
    * Database connection is closed
    """
    -- '-' içeren referanslar
    SELECT DISTINCT user_id FROM support_tickets WHERE reference_no LIKE '%-%';
    -- '-' içermeyen referanslar
    SELECT DISTINCT user_id FROM support_tickets WHERE reference_no NOT LIKE '%-%';
    """

  # @DB29 — orders: is_paid=1 için grand_total ortalaması
  @DB29
  Scenario: US29 Average grand_total of paid orders
    # Finansal ortalama metrik; 2 ondalık yuvarlama
    * Execute AVG query
    * Database connection is closed
    """
    -- Ödenmiş siparişlerin ortalaması
    SELECT ROUND(AVG(grand_total),2) AS avg_grand_total
    FROM orders
    WHERE is_paid = 1;
    """

  # @DB30 — carts: 2024-03-30'dan önce is_buy_now=1 toplam tutar
  @DB30
  Scenario: US30 Total cost of buy-now products before date
    # Tarih sabit; ihtiyaç halinde parametreleştirilebilir (:date)
    * Execute sum query with date filter
    * Database connection is closed
    """
    -- Sepette anında satın al toplam tutarı (tarih filtresiyle)
    SELECT COALESCE(SUM(total_price),0) AS total_buy_now
    FROM carts
    WHERE is_buy_now=1 AND created_at < '2024-03-30';
    """


