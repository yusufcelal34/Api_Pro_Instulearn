@ramazan
Feature: BACKEND JDBC TESTING

  # Bu feature, JDBC ile MySQL üzerinde doğrulama ve veri işleme senaryolarını içerir.
  # Her senaryo: Bağlantı -> Sorgu/İşlem -> Doğrulama -> Bağlantıyı kapat akışını izler.

  Background: Database connection
    # Test başlangıcında DB bağlantısı kuruluyor
    * Database connection is established.



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


