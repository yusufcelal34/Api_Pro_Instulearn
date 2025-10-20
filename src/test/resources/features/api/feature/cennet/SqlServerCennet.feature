@cennetdb
Feature: BACKEND JDBC TESTING

  Background: Database connection
    * Database connection is established.

  @DB04
  Scenario: US04 Insert contact and update message
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

  @DB05
  Scenario: US05 Insert then delete contact by email
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

  @DB06
  Scenario: US06 Count products per coupon
    * Run grouped count by coupon_id
    * Verify grouped result
    * Database connection is closed
    """
    SELECT coupon_id, COUNT(*) AS product_count
    FROM coupon_products
    GROUP BY coupon_id;
    """
