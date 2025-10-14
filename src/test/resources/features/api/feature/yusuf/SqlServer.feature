@DB
Feature: BACKEND JDBC TESTING

  # Bu feature, JDBC ile MySQL üzerinde doğrulama ve veri işleme senaryolarını içerir.
  # Her senaryo: Bağlantı -> Sorgu/İşlem -> Doğrulama -> Bağlantıyı kapat akışını izler.

  Background: Database connection
    # Test başlangıcında DB bağlantısı kuruluyor
    * Database connection is established.

  # @DB31 — Ürün değerlendirme istatistikleri ve minimum puan < 3 doğrulaması
  @DB31
  Scenario: US31 Review stats for a product; validate min rating < 3
    # Belirli bir ürün için toplam/ortalama/en yüksek/en düşük puanlar hesaplanır
    * Execute review stats query by :product_id
      """
      -- Ürün değerlendirme istatistikleri (örnek referans)
      SELECT product_id,
             COUNT(*) AS total_reviews,
             ROUND(AVG(rating),2) AS avg_rating,
             MAX(rating) AS highest_rating,
             MIN(rating) AS lowest_rating
      FROM product_reviews
      WHERE product_id = :product_id
      GROUP BY product_id
      HAVING MIN(rating) < 3;
      """
    * Verify result exists only if MIN(rating) < 3
    * Database connection is closed

  # @DB32 — Departman bazında destek talepleri: durum kırılımı ve adetler
  @DB31
  Scenario: US32 Support tickets by department and status
    # Her departman (id & title) için ticket sayısı ve status dağılımı
    * Run grouping by department and status
      """
      -- Departman ve durum bazlı destek talepleri (örnek referans)
      SELECT d.id AS department_id, d.title AS department_title,
             s.status, COUNT(*) AS ticket_count
      FROM supports s
      JOIN departments d ON d.id = s.department_id
      GROUP BY d.id, d.title, s.status
      ORDER BY d.id, s.status;
      """
    * Verify grouped counts returned
    * Database connection is closed

  # @DB33 — Son 30 günde üretilmiş, aktif ve stoğu > 0 ürünler (yoksa yok bilgisini doğrula)
  @DB31
  Scenario: US33 Active in-stock products created in last 30 days
    # Ürün bulunamazsa test "informational note" olarak 'no product found' kabul edilir
    * Execute products filter query for last 30 days
      """
      -- Aktif ve stoklu yeni ürünler (örnek referans)
      SELECT id, title, stock, is_active, created_at
      FROM products
      WHERE stock > 0
        AND is_active = 1
        AND created_at >= NOW() - INTERVAL 30 DAY;
      """
    * If zero rows, assert informational note
    * Database connection is closed